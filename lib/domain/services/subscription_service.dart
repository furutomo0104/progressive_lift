/// 無料 / プレミアムプラン制御（モック）
class SubscriptionService {
  bool _isPremium = false;

  bool get isPremium => _isPremium;

  Future<bool> checkPremiumStatus() async => _isPremium;

  /// デモ用: プレミアム切り替え
  Future<void> setPremium(bool value) async {
    _isPremium = value;
  }

  bool canUseAiSuggest() => _isPremium;
}
