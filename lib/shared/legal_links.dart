import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// 利用規約・プライバシーポリシーのリンク
class LegalLinks {
  LegalLinks._();

  /// Apple 標準 EULA
  static const termsOfUseUrl =
      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';

  static const privacyPolicyUrl =
      'https://furutomo0104.github.io/kinkiroku/privacy';

  static Future<void> open(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.of(context);
    if (url.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('ページを準備中です。')),
      );
      return;
    }
    final launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      messenger.showSnackBar(
        const SnackBar(content: Text('ページを開けませんでした。')),
      );
    }
  }
}
