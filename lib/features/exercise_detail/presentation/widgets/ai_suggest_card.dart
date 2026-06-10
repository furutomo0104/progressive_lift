import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/providers/app_providers.dart';

class AiSuggestCard extends ConsumerWidget {
  const AiSuggestCard({super.key, required this.exerciseKey});

  final String exerciseKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(premiumToggleProvider);
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
                  color: isPremium ? Colors.amber : Colors.white38,
                ),
                const SizedBox(width: 8),
                Text(
                  'AIサジェスト',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (!isPremium)
                  TextButton(
                    onPressed: () => ref.read(premiumToggleProvider.notifier).toggle(),
                    child: const Text('プレミアムを試す'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            suggestionAsync.when(
              data: (text) {
                if (!isPremium) {
                  return Text(
                    'プレミアムプランで、過去のトップセット傾きから今日の推奨重量・回数をAIが提案します。',
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
