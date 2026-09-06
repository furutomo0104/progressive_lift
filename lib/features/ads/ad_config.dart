import 'dart:io';

/// AdMob 広告ユニットID（現在は Google 公式テストID）
///
/// 本番提出前に、AdMob コンソールで発行した本番IDへ差し替える。
class AdConfig {
  AdConfig._();

  /// テスト用アプリID（Info.plist / AndroidManifest 側にも同値を設定）
  static const String iosAppId = 'ca-app-pub-3940256099942544~1458002511';
  static const String androidAppId = 'ca-app-pub-3940256099942544~3347511713';

  /// バナー（iOS / Android それぞれのテストユニット）
  static const String _iosBannerUnitId =
      'ca-app-pub-3940256099942544/2934735716';
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

  /// インタースティシャルの最小間隔
  static const Duration interstitialMinInterval = Duration(hours: 6);

  /// 1日あたりの最大表示回数
  static const int interstitialMaxPerDay = 2;
}
