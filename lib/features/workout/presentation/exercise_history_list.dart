import 'package:flutter/material.dart';
import 'package:progressive_lift/data/repositories/workout_repository.dart';

class ExerciseHistoryList extends StatelessWidget {
  const ExerciseHistoryList({super.key, required this.history});

  final List<ExerciseHistoryEntry> history;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Text('過去の記録はありません', style: TextStyle(color: Colors.white54)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '過去の履歴',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        ...history.take(5).map((entry) {
          final setsLabel = entry.allSets
              .map((s) => '${s.weightKg}×${s.reps}')
              .join(' / ');
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              dense: true,
              title: Text(
                'TOP ${entry.topSet.weightKg}kg × ${entry.topSet.reps}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${entry.date.month}/${entry.date.day}  $setsLabel',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }),
      ],
    );
  }
}
