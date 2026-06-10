import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/data/models/exercise_record.dart';
import 'package:progressive_lift/data/models/exercise_set.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/widgets/mini_top_set_chart.dart';
import 'package:progressive_lift/providers/app_providers.dart';
import 'package:progressive_lift/shared/widgets/muscle_group_chip.dart';
import 'package:progressive_lift/shared/widgets/swipe_delete_tile.dart';

class ExerciseCard extends HookConsumerWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.sets,
    required this.expanded,
    required this.onToggle,
    required this.onChanged,
  });

  final ExerciseRecord exercise;
  final List<ExerciseSet> sets;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightCtrl = useTextEditingController();
    final repsCtrl = useTextEditingController();

    Future<void> addSet() async {
      final w = double.tryParse(weightCtrl.text);
      final r = int.tryParse(repsCtrl.text);
      if (w == null || r == null) return;
      final repo = await ref.read(workoutRepositoryProvider.future);
      await repo.addSet(
        exerciseRecordId: exercise.id,
        weightKg: w,
        reps: r,
      );
      weightCtrl.clear();
      repsCtrl.clear();
      ref.invalidate(topSetSeriesProvider(exercise.exerciseKey));
      onChanged();
    }

    Future<void> deleteSet(ExerciseSet set) async {
      final repo = await ref.read(workoutRepositoryProvider.future);
      await repo.deleteSet(set.id, exercise.id);
      ref.invalidate(topSetSeriesProvider(exercise.exerciseKey));
      onChanged();
    }

    Future<void> deleteExercise() async {
      final repo = await ref.read(workoutRepositoryProvider.future);
      await repo.deleteExercise(exercise.id);
      ref.invalidate(topSetSeriesProvider(exercise.exerciseKey));
      onChanged();
    }

    return SwipeDeleteTile(
      key: ValueKey('exercise-${exercise.id}'),
      onDelete: deleteExercise,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 36,
                      decoration: BoxDecoration(
                        color: exercise.muscleGroup.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            sets.isEmpty
                                ? 'セット未記録'
                                : '${sets.length}セット',
                            style: TextStyle(
                              fontSize: 13,
                              color: sets.isEmpty
                                  ? Colors.white38
                                  : Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MuscleGroupChip(
                      group: exercise.muscleGroup,
                      compact: true,
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      expanded ? Icons.expand_less : Icons.chevron_right,
                      color: Colors.white38,
                    ),
                  ],
                ),
              ),
            ),
            if (expanded) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (sets.isEmpty)
                      const Text(
                        '重量と回数を入力してセットを追加',
                        style: TextStyle(color: Colors.white54, fontSize: 13),
                      )
                    else
                      ...sets.map(
                        (s) => SwipeDeleteTile(
                          key: ValueKey('set-${s.id}'),
                          onDelete: () => deleteSet(s),
                          child: Container(
                            color: const Color(0xFF1A1D26),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 28,
                                  child: Text(
                                    '${s.setOrder + 1}',
                                    style: const TextStyle(
                                      color: Colors.white38,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${s.weightKg} kg',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const Text(
                                  ' × ',
                                  style: TextStyle(color: Colors.white38),
                                ),
                                Text(
                                  '${s.reps} reps',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: weightCtrl,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'kg',
                              isDense: true,
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: repsCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'reps',
                              isDense: true,
                            ),
                            onSubmitted: (_) => addSet(),
                          ),
                        ),
                        const SizedBox(width: 4),
                        FilledButton(
                          onPressed: addSet,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(48, 48),
                          ),
                          child: const Icon(Icons.add, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    MiniTopSetChart(
                      exerciseKey: exercise.exerciseKey,
                      exerciseName: exercise.name,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
