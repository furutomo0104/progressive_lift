import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/domain/models/selectable_exercise.dart';
import 'package:progressive_lift/providers/app_providers.dart';

Future<bool?> showEditExerciseSheet(
  BuildContext context, {
  required SelectableExercise exercise,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _EditExerciseSheet(exercise: exercise),
  );
}

class _EditExerciseSheet extends HookConsumerWidget {
  const _EditExerciseSheet({required this.exercise});

  final SelectableExercise exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameCtrl = useTextEditingController(text: exercise.name);
    final selectedGroup = useState(exercise.muscleGroup);
    final saving = useState(false);

    Future<void> save() async {
      final name = nameCtrl.text.trim();
      if (name.isEmpty) return;
      saving.value = true;
      final repo = await ref.read(workoutRepositoryProvider.future);
      if (exercise.isCustom && exercise.customTemplateId != null) {
        await repo.updateCustomTemplate(
          id: exercise.customTemplateId!,
          name: name,
          muscleGroup: selectedGroup.value,
        );
      } else {
        await repo.updatePresetExercise(
          exerciseKey: exercise.exerciseKey,
          name: name,
          muscleGroup: selectedGroup.value,
        );
      }
      ref.read(exerciseCatalogTickProvider.notifier).bump();
      ref.invalidate(customExerciseTemplatesProvider);
      saving.value = false;
      if (!context.mounted) return;
      Navigator.pop(context, true);
    }

    Future<void> confirmDelete() async {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('種目を削除'),
          content: Text(
            exercise.isCustom
                ? '「${exercise.name}」を一覧から削除します。\n過去の記録は残ります。'
                : '「${exercise.name}」を一覧から非表示にします。\n過去の記録は残ります。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
              ),
              child: const Text('削除'),
            ),
          ],
        ),
      );
      if (ok != true || !context.mounted) return;

      saving.value = true;
      final repo = await ref.read(workoutRepositoryProvider.future);
      if (exercise.isCustom && exercise.customTemplateId != null) {
        await repo.deleteCustomTemplate(exercise.customTemplateId!);
      } else {
        await repo.hidePresetExercise(exercise.exerciseKey);
      }
      ref.read(exerciseCatalogTickProvider.notifier).bump();
      ref.invalidate(customExerciseTemplatesProvider);
      saving.value = false;
      if (!context.mounted) return;
      Navigator.pop(context, true);
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
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
            const SizedBox(height: 16),
            Text(
              '種目を編集',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              exercise.isCustom ? 'カスタム種目' : 'デフォルト種目',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: '種目名',
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            const Text(
              '部位',
              style: TextStyle(fontSize: 13, color: Colors.white54),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MuscleGroup.selectable.map((g) {
                final selected = selectedGroup.value == g;
                return FilterChip(
                  label: Text(g.label),
                  selected: selected,
                  avatar: CircleAvatar(
                    backgroundColor: g.color,
                    radius: 6,
                  ),
                  onSelected: (_) => selectedGroup.value = g,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: saving.value ? null : save,
              child: saving.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('保存'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: saving.value ? null : confirmDelete,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('一覧から削除'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE57373),
                side: const BorderSide(color: Color(0xFFE57373)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
