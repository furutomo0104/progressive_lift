import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progressive_lift/data/repositories/workout_repository.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/widgets/session_set_composition.dart';

class ExerciseDetailHistoryTab extends StatelessWidget {
  const ExerciseDetailHistoryTab({super.key, required this.history});

  final List<ExerciseHistoryEntry> history;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            '過去の記録はありません',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    final dateFmt = DateFormat('yyyy/M/d');

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final entry = history[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  dateFmt.format(entry.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7986CB).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'TOP ${entry.topSet.weightKg}kg × ${entry.topSet.reps}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7986CB),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SessionSetComposition(sets: entry.allSets),
          ],
        );
      },
    );
  }
}
