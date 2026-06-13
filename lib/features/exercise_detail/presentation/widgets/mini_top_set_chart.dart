import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/exercise_detail_screen.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/widgets/top_set_combo_chart.dart';
import 'package:progressive_lift/providers/app_providers.dart';

/// 記録画面用のコンパクトなトップセットグラフ
class MiniTopSetChart extends ConsumerWidget {
  const MiniTopSetChart({
    super.key,
    required this.exerciseKey,
    required this.exerciseName,
  });

  final String exerciseKey;
  final String exerciseName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(topSetSeriesProvider(exerciseKey));

    return seriesAsync.when(
      data: (points) {
        if (points.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '記録が増えると成長グラフが表示されます',
              style: TextStyle(color: Colors.white54, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          );
        }

        final previous =
            points.length >= 2 ? points[points.length - 2] : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.history, size: 18, color: Color(0xFFFFB74D)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    previous != null
                        ? '前回TOP ${previous.weightKg}kg × ${previous.reps}'
                        : '前回の記録なし',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: previous != null
                          ? Colors.white
                          : Colors.white54,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ExerciseDetailScreen(
                          exerciseKey: exerciseKey,
                          exerciseName: exerciseName,
                        ),
                      ),
                    );
                  },
                  child: const Text('詳細'),
                ),
              ],
            ),
            TopSetComboChart(
              points: points,
              height: 160,
            ),
          ],
        );
      },
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
