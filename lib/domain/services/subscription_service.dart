import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// サブスクリプション管理サービス（RevenueCat連携 ＆ ローカルフォールバック対応）
class SubscriptionService {
  SubscriptionService._();
  static final SubscriptionService instance = SubscriptionService._();

  static const String entitlementPro = 'pro_features';
  static const String monthlyPackageId = '\$rc_monthly';

  // APIキー（環境変数やCIビルドから注入可能）
  static const String _apiKeyApple =
      String.fromEnvironment('REVENUECAT_APPLE_KEY');
  static const String _apiKeyGoogle =
      String.fromEnvironment('REVENUECAT_GOOGLE_KEY');

  bool _isInitialized = false;
  bool _mockIsPro = false; // デバッグ・API未設定環境用の状態

  /// RevenueCat の初期化
  Future<void> init() async {
    if (_isInitialized) return;

    final apiKey = Platform.isIOS
        ? _apiKeyApple
        : (Platform.isAndroid ? _apiKeyGoogle : '');

    if (apiKey.trim().isEmpty) {
      debugPrint(
        'SubscriptionService: RevenueCat API Key not provided. Running in mock/offline mode.',
      );
      _isInitialized = true;
      return;
    }

    try {
      await Purchases.setLogLevel(
        kDebugMode ? LogLevel.debug : LogLevel.error,
      );

      final configuration = PurchasesConfiguration(apiKey);
      await Purchases.configure(configuration);
      _isInitialized = true;
    } catch (e, stack) {
      debugPrint('SubscriptionService init error: $e\n$stack');
      _isInitialized = true;
    }
  }

  /// 現在のPro会員状態を確認
  Future<bool> isProUser() async {
    if (!_isInitialized) {
      await init();
    }

    final apiKey = Platform.isIOS
        ? _apiKeyApple
        : (Platform.isAndroid ? _apiKeyGoogle : '');

    if (apiKey.trim().isEmpty) {
      return _mockIsPro;
    }

    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all[entitlementPro]?.isActive ?? false;
    } catch (e) {
      debugPrint('SubscriptionService isProUser check failed: $e');
      return _mockIsPro;
    }
  }

  /// Offerings（購入可能プラン）を取得
  Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('SubscriptionService getOfferings failed: $e');
      return null;
    }
  }

  /// Pro月額プランを購入
  Future<bool> purchasePackage(Package package) async {
    try {
      final customerInfo = await Purchases.purchasePackage(package);
      return customerInfo.entitlements.all[entitlementPro]?.isActive ?? false;
    } catch (e) {
      debugPrint('SubscriptionService purchasePackage failed: $e');
      return false;
    }
  }

  /// 購入の復元（リストア）
  Future<bool> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.all[entitlementPro]?.isActive ?? false;
    } catch (e) {
      debugPrint('SubscriptionService restorePurchases failed: $e');
      return false;
    }
  }

  /// デバッグ用・モック状態の切り替え
  void setMockPro(bool isPro) {
    _mockIsPro = isPro;
  }
}
