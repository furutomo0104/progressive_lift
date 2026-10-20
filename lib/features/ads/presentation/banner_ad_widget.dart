import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/features/ads/ad_config.dart';
import 'package:progressive_lift/providers/app_providers.dart';

/// 無料ユーザー向け下部バナー。PRO時・テスト時・ロード失敗時は非表示。
class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _loadAttempted = false;
  Timer? _retryTimer;
  int _failureCount = 0;

  static bool get _isFlutterTest =>
      Platform.environment.containsKey('FLUTTER_TEST');

  @override
  void dispose() {
    _retryTimer?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  /// 失敗するたびに 30秒 → 60秒 → … と間隔を延ばし、最大5分ごとに再試行する。
  void _scheduleRetry() {
    _retryTimer?.cancel();
    _failureCount++;
    final seconds = (30 * (1 << (_failureCount - 1))).clamp(30, 300);
    _retryTimer = Timer(Duration(seconds: seconds), () {
      if (!mounted) return;
      final isPro =
          ref.read(proSubscriptionNotifierProvider).valueOrNull ?? false;
      if (isPro) return;
      _loadAttempted = false;
      _loadAd();
    });
  }

  void _loadAd() {
    if (_isFlutterTest || _loadAttempted) return;
    _loadAttempted = true;

    final ad = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          _failureCount = 0;
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
              _isLoaded = false;
            });
            _scheduleRetry();
          }
        },
      ),
    );
    ad.load();
  }

  void _disposeAd() {
    _retryTimer?.cancel();
    _retryTimer = null;
    _failureCount = 0;
    _bannerAd?.dispose();
    _bannerAd = null;
    _isLoaded = false;
    _loadAttempted = false;
  }

  @override
  Widget build(BuildContext context) {
    final isPro =
        ref.watch(proSubscriptionNotifierProvider).valueOrNull ?? false;

    if (isPro || _isFlutterTest) {
      if (_bannerAd != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(_disposeAd);
          }
        });
      }
      return const SizedBox.shrink();
    }

    if (!_loadAttempted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadAd();
      });
    }

    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return ColoredBox(
      color: const Color(0xFF0E1117),
      child: SafeArea(
        top: false,
        child: Center(
          child: SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        ),
      ),
    );
  }
}
