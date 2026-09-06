import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/features/paywall/presentation/paywall_sheet.dart';
import 'package:progressive_lift/providers/app_providers.dart';

class AiSuggestCard extends ConsumerWidget {
  const AiSuggestCard({super.key, required this.exerciseKey});

  final String exerciseKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPro = ref.watch(proSubscriptionNotifierProvider).valueOrNull ?? false;
    final suggestionAsync = ref.watch(aiSuggestionProvider(exerciseKey));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: isPro ? Colors.amber : Colors.white38,
                ),
                const SizedBox(width: 8),
                Text(
                  'AI 今日の推奨セット',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (!isPro)
                  TextButton(
                    onPressed: () => showPaywallSheet(
                      context,
                      featureTriggerTitle: 'AI 推奨セット',
                    ),
                    child: const Text('PROで解放'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            suggestionAsync.when(
              data: (text) {
                if (!isPro) {
                  return Text(
                    'PROプラン（¥250/月）で、過去のトップセット推移から今日の推奨重量・回数をAIが自動提案します。',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white60,
                        ),
                  );
                }
                return Text(
                  text ?? '十分なデータがありません',
                  style: Theme.of(context).textTheme.bodyLarge,
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('エラー: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
