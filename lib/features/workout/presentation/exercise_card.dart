import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
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
    final memoCtrl = useTextEditingController();
    final repsFocus = useFocusNode();
    final showMemoInput = useState(false);
    final editingSetId = useState<int?>(null);

    final muscle = exercise.muscleGroup.displayGroup;

    Future<void> addSet() async {
      final w = double.tryParse(weightCtrl.text);
      final r = int.tryParse(repsCtrl.text);
      if (w == null || r == null) return;
      final repo = await ref.read(workoutRepositoryProvider.future);
      await repo.addSet(
        exerciseRecordId: exercise.id,
        weightKg: w,
        reps: r,
        memo: memoCtrl.text,
      );
      repsCtrl.clear();
      if (!showMemoInput.value) memoCtrl.clear();
      ref.invalidate(topSetSeriesProvider(exercise.exerciseKey));
      onChanged();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (repsFocus.canRequestFocus) repsFocus.requestFocus();
      });
    }

    Future<void> deleteSet(ExerciseSet set) async {
      final repo = await ref.read(workoutRepositoryProvider.future);
      await repo.deleteSet(set.id, exercise.id);
      if (editingSetId.value == set.id) editingSetId.value = null;
      ref.invalidate(topSetSeriesProvider(exercise.exerciseKey));
      onChanged();
    }

    Future<void> deleteExercise() async {
      final repo = await ref.read(workoutRepositoryProvider.future);
      await repo.deleteExercise(exercise.id);
      ref.invalidate(topSetSeriesProvider(exercise.exerciseKey));
      onChanged();
    }

    void dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwipeDeleteTile(
            key: ValueKey('exercise-header-${exercise.id}'),
            groupTag: 'exercise',
            onDelete: deleteExercise,
            child: InkWell(
              onTap: onToggle,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 36,
                      decoration: BoxDecoration(
                        color: muscle.color,
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
                    MuscleGroupChip(group: muscle, compact: true),
                    const SizedBox(width: 8),
                    Icon(
                      expanded ? Icons.expand_less : Icons.chevron_right,
                      color: Colors.white38,
                    ),
                  ],
                ),
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
                      (s) => _SetRow(
                        key: ValueKey('set-${s.id}'),
                        set: s,
                        exerciseId: exercise.id,
                        editing: editingSetId.value == s.id,
                        onTap: () => editingSetId.value =
                            editingSetId.value == s.id ? null : s.id,
                        onDelete: () => deleteSet(s),
                        onSaved: () {
                          editingSetId.value = null;
                          ref.invalidate(
                            topSetSeriesProvider(exercise.exerciseKey),
                          );
                          onChanged();
                        },
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
                          focusNode: repsFocus,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'reps',
                            isDense: true,
                          ),
                          textInputAction: showMemoInput.value
                              ? TextInputAction.next
                              : TextInputAction.done,
                          onSubmitted: (_) {
                            if (!showMemoInput.value) addSet();
                          },
                        ),
                      ),
                      IconButton(
                        tooltip: 'メモ',
                        onPressed: () =>
                            showMemoInput.value = !showMemoInput.value,
                        icon: Icon(
                          showMemoInput.value
                              ? Icons.notes
                              : Icons.notes_outlined,
                          color: showMemoInput.value
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white38,
                          size: 22,
                        ),
                      ),
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
                  if (showMemoInput.value) ...[
                    const SizedBox(height: 8),
                    TextField(
                      controller: memoCtrl,
                      decoration: const InputDecoration(
                        labelText: 'メモ',
                        hintText: '補助・パーシャル・Failed など',
                        isDense: true,
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => addSet(),
                    ),
                  ],
                  if (MediaQuery.viewInsetsOf(context).bottom > 0)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: dismissKeyboard,
                        icon: const Icon(Icons.keyboard_hide, size: 18),
                        label: const Text('キーボードを閉じる'),
                      ),
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
    );
  }
}

class _SetRow extends HookConsumerWidget {
  const _SetRow({
    super.key,
    required this.set,
    required this.exerciseId,
    required this.editing,
    required this.onTap,
    required this.onDelete,
    required this.onSaved,
  });

  final ExerciseSet set;
  final int exerciseId;
  final bool editing;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weightCtrl = useTextEditingController(text: '${set.weightKg}');
    final repsCtrl = useTextEditingController(text: '${set.reps}');
    final memoCtrl = useTextEditingController(text: set.memo ?? '');

    useEffect(() {
      weightCtrl.text = '${set.weightKg}';
      repsCtrl.text = '${set.reps}';
      memoCtrl.text = set.memo ?? '';
      return null;
    }, [set.id, set.weightKg, set.reps, set.memo]);

    Future<void> save() async {
      final w = double.tryParse(weightCtrl.text);
      final r = int.tryParse(repsCtrl.text);
      if (w == null || r == null) return;
      final repo = await ref.read(workoutRepositoryProvider.future);
      await repo.updateSet(
        setId: set.id,
        exerciseRecordId: exerciseId,
        weightKg: w,
        reps: r,
        memo: memoCtrl.text,
      );
      FocusManager.instance.primaryFocus?.unfocus();
      onSaved();
    }

    if (editing) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D26),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'セット ${set.setOrder + 1} を編集',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 8),
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: memoCtrl,
              decoration: const InputDecoration(
                labelText: 'メモ',
                hintText: '補助・パーシャル・Failed など',
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onTap,
                  child: const Text('キャンセル'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: save,
                  child: const Text('保存'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return SwipeDeleteTile(
      groupTag: 'set-$exerciseId',
      onDelete: onDelete,
      child: Material(
        color: const Color(0xFF1A1D26),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '${set.setOrder + 1}',
                    style: const TextStyle(color: Colors.white38),
                  ),
                ),
                Text(
                  '${set.weightKg} kg',
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
                  '${set.reps} reps',
                  style: const TextStyle(fontSize: 15),
                ),
                if (set.memo != null && set.memo!.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      set.memo!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ] else
                  const Spacer(),
                if (set.recordedAt != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      DateFormat('HH:mm').format(set.recordedAt!),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white30,
                      ),
                    ),
                  ),
                const Icon(Icons.edit_outlined, size: 16, color: Colors.white24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
