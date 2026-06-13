import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/domain/models/top_set_point.dart';
import 'package:progressive_lift/domain/services/one_rm_calculator.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/widgets/ai_suggest_card.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/widgets/estimated_one_rm_chart.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/widgets/exercise_detail_history_tab.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/widgets/top_set_combo_chart.dart';
import 'package:progressive_lift/providers/app_providers.dart';

enum _DetailTab { topSet, oneRm, history }

class ExerciseDetailScreen extends HookConsumerWidget {
  const ExerciseDetailScreen({
    super.key,
    required this.exerciseKey,
    this.exerciseName,
  });

  final String exerciseKey;
  final String? exerciseName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = useState(_DetailTab.topSet);
    final seriesAsync = ref.watch(topSetSeriesProvider(exerciseKey));
    final historyAsync = ref.watch(exerciseHistoryProvider(exerciseKey));
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
          final oneRmPoints = OneRmCalculator.fromTopSetSeries(points);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (previous != null) ...[
                _PreviousTopBadge(point: previous),
                const SizedBox(height: 16),
              ],
              SegmentedButton<_DetailTab>(
                segments: const [
                  ButtonSegment(
                    value: _DetailTab.topSet,
                    label: Text('トップセット'),
                  ),
                  ButtonSegment(
                    value: _DetailTab.oneRm,
                    label: Text('1RM'),
                  ),
                  ButtonSegment(
                    value: _DetailTab.history,
                    label: Text('履歴'),
                  ),
                ],
                selected: {selectedTab.value},
                onSelectionChanged: (s) => selectedTab.value = s.first,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tabTitle(selectedTab.value),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (selectedTab.value == _DetailTab.topSet) ...[
                        const SizedBox(height: 4),
                        Text(
                          '線 = 最高重量　棒 = その日のReps',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white54,
                                  ),
                        ),
                      ],
                      if (selectedTab.value == _DetailTab.oneRm) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Epley式による推定1RM（kg）',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white54,
                                  ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      switch (selectedTab.value) {
                        _DetailTab.topSet => TopSetComboChart(
                            points: points,
                            height: 280,
                          ),
                        _DetailTab.oneRm => EstimatedOneRmChart(
                            points: oneRmPoints,
                            height: 280,
                          ),
                        _DetailTab.history => historyAsync.when(
                            data: (history) =>
                                ExerciseDetailHistoryTab(history: history),
                            loading: () => const Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            error: (e, _) => Text('履歴の読み込みエラー: $e'),
                          ),
                      },
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

  static String _tabTitle(_DetailTab tab) => switch (tab) {
        _DetailTab.topSet => 'トップセット推移',
        _DetailTab.oneRm => '推定1RM推移',
        _DetailTab.history => 'セット履歴',
      };
}

class _PreviousTopBadge extends StatelessWidget {
  const _PreviousTopBadge({required this.point});

  final TopSetPoint point;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFB74D).withValues(alpha: 0.2),
            const Color(0xFFFFB74D).withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFB74D).withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.history, color: Color(0xFFFFB74D)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '前回TOP ${point.weightKg}kg × ${point.reps}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
