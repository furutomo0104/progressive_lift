import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/domain/models/exercise_list_item.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/exercise_detail_screen.dart';
import 'package:progressive_lift/providers/app_providers.dart';
import 'package:progressive_lift/shared/widgets/muscle_group_chip.dart';

class ExercisesScreen extends HookConsumerWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(exerciseListItemsProvider);
    final query = useState('');
    final filterGroup = useState<MuscleGroup?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('種目'),
      ),
      body: itemsAsync.when(
        data: (items) {
          final filtered = items.where((item) {
            if (filterGroup.value != null &&
                item.muscleGroup != filterGroup.value) {
              return false;
            }
            if (query.value.isEmpty) return true;
            final q = query.value.trim().toLowerCase();
            return item.name.toLowerCase().contains(q);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: '種目を検索…',
                    prefixIcon: Icon(Icons.search, size: 20),
                    isDense: true,
                  ),
                  onChanged: (v) => query.value = v,
                ),
              ),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: const Text('すべて'),
                        selected: filterGroup.value == null,
                        onSelected: (_) => filterGroup.value = null,
                      ),
                    ),
                    for (final g in MuscleGroup.selectable)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(g.label),
                          selected: filterGroup.value == g,
                          avatar: CircleAvatar(
                            backgroundColor: g.color,
                            radius: 6,
                          ),
                          onSelected: (_) => filterGroup.value = g,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          items.isEmpty
                              ? '記録した種目がここに表示されます'
                              : '該当する種目がありません',
                          style: const TextStyle(color: Colors.white54),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) =>
                            _ExerciseListTile(item: filtered[i]),
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('エラー: $e')),
      ),
    );
  }
}

class _ExerciseListTile extends StatelessWidget {
  const _ExerciseListTile({required this.item});

  final ExerciseListItem item;

  @override
  Widget build(BuildContext context) {
    final top = item.latestTop;
    final dateLabel = item.lastTrainedDate != null
        ? DateFormat('M/d').format(item.lastTrainedDate!)
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ExerciseDetailScreen(
                exerciseKey: item.exerciseKey,
                exerciseName: item.name,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: item.muscleGroup.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        MuscleGroupChip(group: item.muscleGroup, compact: true),
                        if (top != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            'TOP ${top.weightKg}kg×${top.reps}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                        if (dateLabel != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            dateLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}
