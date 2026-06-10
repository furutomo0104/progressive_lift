import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/core/constants/exercise_catalog.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/data/models/custom_exercise_template.dart';
import 'package:progressive_lift/providers/app_providers.dart';
import 'package:progressive_lift/shared/widgets/muscle_group_chip.dart';

class AddExerciseResult {
  const AddExerciseResult({
    required this.exerciseKey,
    required this.name,
    required this.muscleGroup,
  });

  final String exerciseKey;
  final String name;
  final MuscleGroup muscleGroup;
}

Future<AddExerciseResult?> showAddExerciseSheet(BuildContext context) {
  return showModalBottomSheet<AddExerciseResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _AddExerciseSheet(),
  );
}

class _AddExerciseSheet extends HookConsumerWidget {
  const _AddExerciseSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchCtrl = useTextEditingController();
    final query = useState('');
    final customNameCtrl = useTextEditingController();
    final selectedGroup = useState(MuscleGroup.chest);
    final customsAsync = ref.watch(customExerciseTemplatesProvider);

    final filtered = query.value.isEmpty
        ? ExerciseCatalog.templates
        : ExerciseCatalog.search(query.value);

    final savedCustoms = customsAsync.maybeWhen(
      data: (list) {
        if (query.value.isEmpty) return list;
        final q = query.value.trim().toLowerCase();
        return list
            .where((c) => c.name.toLowerCase().contains(q))
            .toList();
      },
      orElse: () => <CustomExerciseTemplate>[],
    );

    final grouped = <MuscleGroup, List<ExerciseTemplate>>{};
    for (final g in MuscleGroup.values) {
      final presets = filtered.where((t) => t.muscleGroup == g).toList();
      if (presets.isNotEmpty) grouped[g] = presets;
    }

    Future<void> pickCustom() async {
      final name = customNameCtrl.text.trim();
      if (name.isEmpty) return;
      final repo = await ref.read(workoutRepositoryProvider.future);
      final template = await repo.saveCustomTemplate(
        name: name,
        muscleGroup: selectedGroup.value,
      );
      ref.invalidate(customExerciseTemplatesProvider);
      if (!context.mounted) return;
      Navigator.pop(
        context,
        AddExerciseResult(
          exerciseKey: template.exerciseKey,
          name: template.name,
          muscleGroup: template.muscleGroup,
        ),
      );
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
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
                child: Text(
                  '種目を追加',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  children: [
                    Text(
                      'カスタム種目を登録',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'マシン名・器具を含めて入力できます',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: customNameCtrl,
                      decoration: const InputDecoration(
                        labelText: '種目名',
                        hintText: '例: スミスインクラインベンチ',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: MuscleGroup.values.map((g) {
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
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: pickCustom,
                      icon: const Icon(Icons.check),
                      label: const Text('登録して追加'),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(),
                    ),
                    TextField(
                      controller: searchCtrl,
                      decoration: const InputDecoration(
                        hintText: 'デフォルト種目を検索…',
                        prefixIcon: Icon(Icons.search, size: 20),
                      ),
                      onChanged: (v) => query.value = v,
                    ),
                    if (savedCustoms.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        '登録済みカスタム種目',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      ...savedCustoms.map(
                        (c) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.bookmark,
                            color: c.muscleGroup.color,
                            size: 20,
                          ),
                          title: Text(c.name),
                          trailing: const Icon(Icons.add_circle_outline),
                          onTap: () => Navigator.pop(
                            context,
                            AddExerciseResult(
                              exerciseKey: c.exerciseKey,
                              name: c.name,
                              muscleGroup: c.muscleGroup,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'デフォルト種目',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '器具が明確な基本種目のみ',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    for (final entry in grouped.entries) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        child: MuscleGroupChip(group: entry.key),
                      ),
                      ...entry.value.map(
                        (t) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.fitness_center,
                            color: t.muscleGroup.color,
                            size: 20,
                          ),
                          title: Text(t.name),
                          trailing: const Icon(Icons.add_circle_outline),
                          onTap: () => Navigator.pop(
                            context,
                            AddExerciseResult(
                              exerciseKey: t.key,
                              name: t.name,
                              muscleGroup: t.muscleGroup,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
