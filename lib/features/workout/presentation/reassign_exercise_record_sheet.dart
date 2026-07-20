import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/domain/models/selectable_exercise.dart';
import 'package:progressive_lift/providers/app_providers.dart';
import 'package:progressive_lift/shared/widgets/muscle_group_chip.dart';

class ReassignExerciseResult {
  const ReassignExerciseResult({
    required this.oldExerciseKey,
    required this.newExerciseKey,
  });

  final String oldExerciseKey;
  final String newExerciseKey;
}

Future<ReassignExerciseResult?> showReassignExerciseRecordSheet(
  BuildContext context, {
  required int recordId,
  required String currentExerciseKey,
  required String currentName,
}) {
  return showModalBottomSheet<ReassignExerciseResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _ReassignExerciseRecordSheet(
      recordId: recordId,
      currentExerciseKey: currentExerciseKey,
      currentName: currentName,
    ),
  );
}

class _ReassignExerciseRecordSheet extends HookConsumerWidget {
  const _ReassignExerciseRecordSheet({
    required this.recordId,
    required this.currentExerciseKey,
    required this.currentName,
  });

  final int recordId;
  final String currentExerciseKey;
  final String currentName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchCtrl = useTextEditingController();
    final query = useState('');
    final saving = useState(false);
    final exercisesAsync = ref.watch(selectableExercisesProvider);

    Future<void> pick(SelectableExercise exercise) async {
      if (exercise.exerciseKey == currentExerciseKey) {
        Navigator.pop(context);
        return;
      }
      saving.value = true;
      final repo = await ref.read(workoutRepositoryProvider.future);
      final oldKey = await repo.reassignExerciseRecord(
        recordId: recordId,
        exerciseKey: exercise.exerciseKey,
        name: exercise.name,
        muscleGroup: exercise.muscleGroup,
      );
      saving.value = false;
      if (!context.mounted || oldKey == null) return;
      Navigator.pop(
        context,
        ReassignExerciseResult(
          oldExerciseKey: oldKey,
          newExerciseKey: exercise.exerciseKey,
        ),
      );
    }

    final items = exercisesAsync.maybeWhen(
      data: (list) {
        if (query.value.isEmpty) return list;
        final q = query.value.trim().toLowerCase();
        return list
            .where(
              (e) =>
                  e.name.toLowerCase().contains(q) ||
                  e.muscleGroup.label.contains(query.value),
            )
            .toList();
      },
      orElse: () => <SelectableExercise>[],
    );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '種目を修正',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '現在: $currentName',
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'セットと重量はそのまま、正しい種目に付け替えます。グラフも移動します。',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: TextField(
                controller: searchCtrl,
                decoration: const InputDecoration(
                  hintText: '種目を検索…',
                  prefixIcon: Icon(Icons.search, size: 20),
                  isDense: true,
                ),
                onChanged: (v) => query.value = v,
              ),
            ),
            if (saving.value)
              const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: exercisesAsync.when(
                data: (_) {
                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        '該当する種目がありません',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }
                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final item = items[i];
                      final isCurrent =
                          item.exerciseKey == currentExerciseKey;
                      return ListTile(
                        leading: Icon(
                          item.isCustom
                              ? Icons.bookmark
                              : Icons.fitness_center,
                          color: item.muscleGroup.color,
                          size: 20,
                        ),
                        title: Text(item.name),
                        subtitle: Row(
                          children: [
                            MuscleGroupChip(
                              group: item.muscleGroup,
                              compact: true,
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              const Text(
                                '現在',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white38,
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing: isCurrent
                            ? const Icon(Icons.check, color: Colors.white38)
                            : const Icon(Icons.chevron_right),
                        onTap: saving.value ? null : () => pick(item),
                      );
                    },
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('エラー: $e')),
              ),
            ),
          ],
        );
      },
    );
  }
}
