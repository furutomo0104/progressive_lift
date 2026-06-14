import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/domain/models/selectable_exercise.dart';
import 'package:progressive_lift/providers/app_providers.dart';
import 'package:progressive_lift/shared/widgets/muscle_group_chip.dart';

class ExerciseReorderScreen extends ConsumerStatefulWidget {
  const ExerciseReorderScreen({super.key});

  @override
  ConsumerState<ExerciseReorderScreen> createState() =>
      _ExerciseReorderScreenState();
}

class _ExerciseReorderScreenState extends ConsumerState<ExerciseReorderScreen> {
  List<SelectableExercise>? _items;
  bool _saving = false;
  bool _dirty = false;

  Future<void> _save() async {
    final items = _items;
    if (items == null || !_dirty) {
      if (mounted) Navigator.pop(context);
      return;
    }

    setState(() => _saving = true);
    final repo = await ref.read(workoutRepositoryProvider.future);
    await repo.reorderExercises(items.map((e) => e.exerciseKey).toList());
    ref.read(exerciseCatalogTickProvider.notifier).bump();
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _onWillPop() async {
    if (!_dirty || _saving) {
      if (mounted) Navigator.pop(context);
      return;
    }

    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('変更を破棄'),
        content: const Text('並び替えの変更を保存せずに戻りますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('破棄'),
          ),
        ],
      ),
    );
    if (discard == true && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(selectableExercisesProvider);

    if (_items == null) {
      itemsAsync.whenData((data) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _items == null) {
            setState(() => _items = List.of(data));
          }
        });
      });
    }

    return PopScope(
      canPop: !_dirty || _saving,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _onWillPop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('並び替え'),
          actions: [
            TextButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('完了'),
            ),
          ],
        ),
        body: itemsAsync.when(
          data: (_) {
            final items = _items;
            if (items == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (items.isEmpty) {
              return const Center(
                child: Text(
                  '並び替えできる種目がありません',
                  style: TextStyle(color: Colors.white54),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Text(
                    '右端の ≡ を長押ししてドラッグ',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    buildDefaultDragHandles: false,
                    itemCount: items.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item = items.removeAt(oldIndex);
                        items.insert(newIndex, item);
                        _dirty = true;
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _ReorderTile(
                        key: ValueKey(item.exerciseKey),
                        item: item,
                        index: index,
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('エラー: $e')),
        ),
      ),
    );
  }
}

class _ReorderTile extends StatelessWidget {
  const _ReorderTile({
    super.key,
    required this.item,
    required this.index,
  });

  final SelectableExercise item;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 4,
          height: 36,
          decoration: BoxDecoration(
            color: item.muscleGroup.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(item.name),
        subtitle: Row(
          children: [
            MuscleGroupChip(group: item.muscleGroup, compact: true),
            if (item.isCustom) ...[
              const SizedBox(width: 8),
              const Text(
                'カスタム',
                style: TextStyle(fontSize: 11, color: Colors.white38),
              ),
            ],
          ],
        ),
        trailing: ReorderableDragStartListener(
          index: index,
          child: Icon(
            Icons.drag_handle,
            color: Colors.white.withValues(alpha: 0.45),
          ),
        ),
      ),
    );
  }
}
