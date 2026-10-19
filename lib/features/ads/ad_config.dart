import 'dart:io';

/// AdMob 広告ユニットID
///
/// iOS のアプリID・バナーは本番ID。Android とインタースティシャルは未発行のため Google 公式テストID。
class AdConfig {
  AdConfig._();

  /// アプリID（Info.plist / AndroidManifest 側にも同値を設定）
  static const String iosAppId = 'ca-app-pub-6501663052630445~3553386097';
  static const String androidAppId = 'ca-app-pub-3940256099942544~3347511713';

  static const String _iosBannerUnitId =
      'ca-app-pub-6501663052630445/7653142159';
  static const String _androidBannerUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  /// インタースティシャル（セッション終了時）
  static const String _iosInterstitialUnitId =
      'ca-app-pub-3940256099942544/4411468910';
  static const String _androidInterstitialUnitId =
      'ca-app-pub-3940256099942544/1033173712';

  static String get bannerAdUnitId =>
      Platform.isIOS ? _iosBannerUnitId : _androidBannerUnitId;

  static String get interstitialAdUnitId =>
      Platform.isIOS ? _iosInterstitialUnitId : _androidInterstitialUnitId;

  /// リリース時はフルスクリーン広告をオフ（バナーのみ）。
  /// 収益が足りない場合に true へ戻す。
  static const bool enableInterstitialAds = false;

  /// インタースティシャルの最小間隔
  /// ※ ✕ボタン出現タイミングは AdMob 側制御のためアプリからは短縮不可。
  static const Duration interstitialMinInterval = Duration(hours: 12);

  /// 1日あたりの最大表示回数
  static const int interstitialMaxPerDay = 1;
}
