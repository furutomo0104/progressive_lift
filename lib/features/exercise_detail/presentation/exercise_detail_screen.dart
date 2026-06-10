import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/domain/models/top_set_point.dart';
import 'package:progressive_lift/domain/services/top_set_extractor.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/widgets/ai_suggest_card.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/widgets/top_set_combo_chart.dart';
import 'package:progressive_lift/providers/app_providers.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  const ExerciseDetailScreen({
    super.key,
    required this.exerciseKey,
    this.exerciseName,
  });

  final String exerciseKey;
  final String? exerciseName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(topSetSeriesProvider(exerciseKey));
    final nameAsync = exerciseName != null
        ? null
        : ref.watch(exerciseNameProvider(exerciseKey));

    final title = exerciseName ??
        nameAsync?.maybeWhen(data: (n) => n, orElse: () => exerciseKey) ??
        exerciseKey;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: seriesAsync.when(
        data: (points) {
          final previous =
              points.length >= 2 ? points[points.length - 2] : null;
          final target = TopSetExtractor.buildTarget(previous);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (points.isNotEmpty) ...[
                _LatestBadge(point: points.last, target: target),
                const SizedBox(height: 16),
              ],
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'トップセット推移',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '線 = 最高重量　棒 = その日のReps',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white54,
                            ),
                      ),
                      const SizedBox(height: 12),
                      TopSetComboChart(
                        points: points,
                        target: target,
                        height: 280,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AiSuggestCard(exerciseKey: exerciseKey),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('読み込みエラー: $e')),
      ),
    );
  }
}

class _LatestBadge extends StatelessWidget {
  const _LatestBadge({required this.point, this.target});

  final TopSetPoint point;
  final WorkoutTarget? target;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7986CB).withValues(alpha: 0.3),
            const Color(0xFF4FC3F7).withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: Color(0xFFFFB74D)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '最新TOP ${point.weightKg}kg × ${point.reps}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (target != null)
                  Text(
                    target!.displayText,
                    style: const TextStyle(
                      color: Color(0xFFFFB74D),
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
