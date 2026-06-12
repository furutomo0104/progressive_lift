import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/domain/models/selectable_exercise.dart';
import 'package:progressive_lift/features/workout/presentation/edit_exercise_sheet.dart';
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

class _MuscleGroupSection {
  _MuscleGroupSection({
    required this.group,
    required this.exercises,
  });

  final MuscleGroup group;
  final List<SelectableExercise> exercises;

  int get totalCount => exercises.length;
}

class _AddExerciseSheet extends HookConsumerWidget {
  const _AddExerciseSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchCtrl = useTextEditingController();
    final query = useState('');
    final customNameCtrl = useTextEditingController();
    final selectedGroup = useState(MuscleGroup.chest);
    final expandedGroups = useState<Set<MuscleGroup>>({});
    final exercisesAsync = ref.watch(selectableExercisesProvider);

    final allExercises = exercisesAsync.maybeWhen(
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

    final sections = <_MuscleGroupSection>[];
    for (final g in MuscleGroup.selectable) {
      final items = allExercises.where((e) => e.muscleGroup == g).toList();
      if (items.isNotEmpty) {
        sections.add(_MuscleGroupSection(group: g, exercises: items));
      }
    }

    useEffect(() {
      if (query.value.isNotEmpty && sections.isNotEmpty) {
        expandedGroups.value = sections.map((s) => s.group).toSet();
      }
      return null;
    }, [query.value, sections.length]);

    Future<void> pickCustom() async {
      final name = customNameCtrl.text.trim();
      if (name.isEmpty) return;
      final repo = await ref.read(workoutRepositoryProvider.future);
      final template = await repo.saveCustomTemplate(
        name: name,
        muscleGroup: selectedGroup.value,
      );
      ref.read(exerciseCatalogTickProvider.notifier).bump();
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

    void toggleGroup(MuscleGroup g) {
      final next = Set<MuscleGroup>.from(expandedGroups.value);
      if (next.contains(g)) {
        next.remove(g);
      } else {
        next.add(g);
      }
      expandedGroups.value = next;
    }

    void pickResult(SelectableExercise e) {
      Navigator.pop(
        context,
        AddExerciseResult(
          exerciseKey: e.exerciseKey,
          name: e.name,
          muscleGroup: e.muscleGroup,
        ),
      );
    }

    Future<void> editExercise(SelectableExercise e) async {
      final changed = await showEditExerciseSheet(context, exercise: e);
      if (changed == true) {
        ref.invalidate(selectableExercisesProvider);
      }
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
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
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
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
                          hintText: '種目を検索…',
                          prefixIcon: Icon(Icons.search, size: 20),
                        ),
                        onChanged: (v) => query.value = v,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '鉛筆アイコンで名前・部位の編集、一覧からの削除ができます',
                        style: TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                      const SizedBox(height: 12),
                      if (exercisesAsync.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (sections.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            '該当する種目がありません',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54),
                          ),
                        )
                      else
                        ...sections.map((section) {
                          final expanded =
                              expandedGroups.value.contains(section.group);
                          return _MuscleGroupAccordion(
                            section: section,
                            expanded: expanded,
                            onToggle: () => toggleGroup(section.group),
                            onPick: pickResult,
                            onEdit: editExercise,
                          );
                        }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MuscleGroupAccordion extends StatelessWidget {
  const _MuscleGroupAccordion({
    required this.section,
    required this.expanded,
    required this.onToggle,
    required this.onPick,
    required this.onEdit,
  });

  final _MuscleGroupSection section;
  final bool expanded;
  final VoidCallback onToggle;
  final void Function(SelectableExercise) onPick;
  final Future<void> Function(SelectableExercise) onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  MuscleGroupChip(group: section.group),
                  const SizedBox(width: 8),
                  Text(
                    '${section.totalCount}種目',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white38,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1),
            ...section.exercises.map(
              (e) => ListTile(
                dense: true,
                leading: Icon(
                  e.isCustom ? Icons.bookmark : Icons.fitness_center,
                  color: section.group.color,
                  size: 20,
                ),
                title: Text(e.name),
                subtitle: e.isCustom
                    ? const Text(
                        'カスタム',
                        style: TextStyle(fontSize: 11, color: Colors.white38),
                      )
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      tooltip: '編集',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => onEdit(e),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 22),
                      tooltip: '追加',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => onPick(e),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
