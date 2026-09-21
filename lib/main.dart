import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:progressive_lift/app.dart';
import 'package:progressive_lift/features/ads/ad_config.dart';
import 'package:progressive_lift/features/ads/interstitial_ad_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ja');

  try {
    await MobileAds.instance.initialize();
    // フルスクリーン広告はリリース時オフ（AdConfig.enableInterstitialAds）
    if (AdConfig.enableInterstitialAds) {
      await InterstitialAdService.instance.preload();
    }
  } catch (e) {
    debugPrint('MobileAds init skipped/failed: $e');
  }

  runApp(const ProgressiveLiftApp());
}
