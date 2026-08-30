import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/domain/services/subscription_service.dart';
import 'package:progressive_lift/providers/app_providers.dart';

/// Proプラン（月額380円）の案内・購入モーダルシートを表示
Future<void> showPaywallSheet(
  BuildContext context, {
  String? featureTriggerTitle,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _PaywallSheet(featureTriggerTitle: featureTriggerTitle),
  );
}

class _PaywallSheet extends HookConsumerWidget {
  const _PaywallSheet({this.featureTriggerTitle});

  final String? featureTriggerTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPurchasing = useState(false);
    final isRestoring = useState(false);
    final proAsync = ref.watch(proSubscriptionNotifierProvider);
    final isPro = proAsync.valueOrNull ?? false;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF14171F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 上部ドラッグバー
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // タイトルバッジ
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium,
                        size: 16, color: Colors.black87),
                    SizedBox(width: 4),
                    Text(
                      '筋記録 PRO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // メイン見出し
            const Text(
              '限界を突破し、最速で筋力向上へ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            if (featureTriggerTitle != null) ...[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_open, size: 16, color: Colors.amber),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Pro加入で「$featureTriggerTitle」が今すぐ解放されます',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ] else ...[
              const Text(
                '広告完全排除・専任AIコーチ・全期間データ閲覧',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Pro特典一覧カード
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E222D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: const Column(
                children: [
                  _FeatureRow(
                    icon: Icons.block,
                    color: Colors.redAccent,
                    title: '広告の完全非表示',
                    subtitle: '記録中・完了時の広告がなくなり、筋トレに100%集中',
                  ),
                  Divider(color: Colors.white10, height: 20),
                  _FeatureRow(
                    icon: Icons.auto_awesome,
                    color: Colors.amber,
                    title: 'AI Overload Coach による無制限月間詳細分析',
                    subtitle: 'Gemini 1.5 Flash が成長要因・プラトー打破・具体的目標を分析',
                  ),
                  Divider(color: Colors.white10, height: 20),
                  _FeatureRow(
                    icon: Icons.all_inclusive,
                    color: Colors.cyanAccent,
                    title: '全期間の過去データ閲覧＆推移グラフ',
                    subtitle: '3ヶ月以上前の過去記録・1RM成長推移を無制限に振り返り',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 価格カード
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2C2411),
                    const Color(0xFF1F2430),
                  ],
                ),
                border: Border.all(
                  color: Colors.amber.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '月額プラン',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'いつでもキャンセル可能',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: const [
                      Text(
                        '¥380',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      Text(
                        ' / 月',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 購入ボタン
            if (isPro)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.greenAccent),
                ),
                child: const Center(
                  child: Text(
                    'PROプランに加入中です',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              ElevatedButton(
                onPressed: isPurchasing.value || isRestoring.value
                    ? null
                    : () async {
                        isPurchasing.value = true;
                        try {
                          final offerings = await SubscriptionService.instance
                              .getOfferings();
                          final monthly = offerings?.current?.monthly;
                          if (monthly != null) {
                            final success = await SubscriptionService.instance
                                .purchasePackage(monthly);
                            if (success && context.mounted) {
                              await ref
                                  .read(
                                      proSubscriptionNotifierProvider.notifier)
                                  .refresh();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('筋記録 PRO へようこそ！全機能が解放されました。'),
                                  backgroundColor: Colors.amber,
                                ),
                              );
                              return;
                            }
                          } else {
                            // モック環境でのテスト用
                            await ref
                                .read(
                                    proSubscriptionNotifierProvider.notifier)
                                .toggleMock();
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('【テスト】PROプランを有効化しました。'),
                                  backgroundColor: Colors.amber,
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('購入処理に失敗しました: $e')),
                            );
                          }
                        } finally {
                          isPurchasing.value = false;
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: isPurchasing.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        '今すぐ PRO を始める（月額 ¥380）',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            const SizedBox(height: 10),

            // リストアボタン
            TextButton(
              onPressed: isPurchasing.value || isRestoring.value
                  ? null
                  : () async {
                      isRestoring.value = true;
                      try {
                        final success = await SubscriptionService.instance
                            .restorePurchases();
                        await ref
                            .read(proSubscriptionNotifierProvider.notifier)
                            .refresh();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? '購入情報を復元しました。'
                                    : '有効な購入情報が見つかりませんでした。',
                              ),
                            ),
                          );
                          if (success) Navigator.of(context).pop();
                        }
                      } finally {
                        isRestoring.value = false;
                      }
                    },
              child: isRestoring.value
                  ? const SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white54,
                      ),
                    )
                  : const Text(
                      '以前の購入を復元する',
                      style: TextStyle(fontSize: 12, color: Colors.white54),
                    ),
            ),
            const SizedBox(height: 6),

            // 注記・規約
            const Text(
              '※ サブスクリプションはいつでも App Store のアカウント設定から解約できます。更新日の24時間前までに解約されない限り自動更新されます。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
