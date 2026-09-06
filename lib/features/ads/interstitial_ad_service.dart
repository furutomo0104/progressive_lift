import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progressive_lift/features/ads/ad_config.dart';

/// インタースティシャル広告のロード・表示（頻度制限付き）
class InterstitialAdService {
  InterstitialAdService._();
  static final InterstitialAdService instance = InterstitialAdService._();

  static const _prefsLastShownKey = 'ad_interstitial_last_shown_ms';
  static const _prefsDayKey = 'ad_interstitial_day';
  static const _prefsDayCountKey = 'ad_interstitial_day_count';

  InterstitialAd? _ad;
  bool _isLoading = false;
  bool _isShowing = false;

  static bool get _isFlutterTest =>
      Platform.environment.containsKey('FLUTTER_TEST');

  Future<void> preload() async {
    if (_isFlutterTest || _ad != null || _isLoading) return;
    _isLoading = true;
    try {
      await InterstitialAd.load(
        adUnitId: AdConfig.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _ad = ad;
            _isLoading = false;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                _ad = null;
                _isShowing = false;
                preload();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                debugPrint('Interstitial show failed: $error');
                ad.dispose();
                _ad = null;
                _isShowing = false;
                preload();
              },
            );
          },
          onAdFailedToLoad: (error) {
            debugPrint('Interstitial load failed: $error');
            _isLoading = false;
            _ad = null;
          },
        ),
      );
    } catch (e) {
      debugPrint('Interstitial preload error: $e');
      _isLoading = false;
    }
  }

  /// 無料ユーザー向け。頻度制限内なら表示を試みる（失敗しても例外を投げない）
  Future<void> showIfAllowed({required bool isPro}) async {
    if (isPro || _isFlutterTest || _isShowing) return;

    try {
      if (!await _canShowNow()) return;

      if (_ad == null) {
        await preload();
        // ロード完了待ちは短く。未ロードならスキップ
        await Future<void>.delayed(const Duration(milliseconds: 400));
      }

      final ad = _ad;
      if (ad == null) return;

      _isShowing = true;
      await ad.show();
      await _markShown();
    } catch (e) {
      debugPrint('Interstitial showIfAllowed error: $e');
      _isShowing = false;
    }
  }

  Future<bool> _canShowNow() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final dayStamp = '${now.year}-${now.month}-${now.day}';
    final storedDay = prefs.getString(_prefsDayKey);
    final dayCount =
        storedDay == dayStamp ? (prefs.getInt(_prefsDayCountKey) ?? 0) : 0;

    if (dayCount >= AdConfig.interstitialMaxPerDay) return false;

    final lastMs = prefs.getInt(_prefsLastShownKey);
    if (lastMs != null) {
      final last = DateTime.fromMillisecondsSinceEpoch(lastMs);
      if (now.difference(last) < AdConfig.interstitialMinInterval) {
        return false;
      }
    }
    return true;
  }

  Future<void> _markShown() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final dayStamp = '${now.year}-${now.month}-${now.day}';
    final storedDay = prefs.getString(_prefsDayKey);
    final dayCount =
        storedDay == dayStamp ? (prefs.getInt(_prefsDayCountKey) ?? 0) : 0;

    await prefs.setInt(_prefsLastShownKey, now.millisecondsSinceEpoch);
    await prefs.setString(_prefsDayKey, dayStamp);
    await prefs.setInt(_prefsDayCountKey, dayCount + 1);
  }

  void dispose() {
    _ad?.dispose();
    _ad = null;
  }
}
