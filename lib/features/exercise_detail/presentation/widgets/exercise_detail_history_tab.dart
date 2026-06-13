import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progressive_lift/data/repositories/workout_repository.dart';

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
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final entry = history[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
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
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    for (var j = 0; j < entry.allSets.length; j++)
                      _SetChip(
                        order: j + 1,
                        weight: entry.allSets[j].weightKg,
                        reps: entry.allSets[j].reps,
                        memo: entry.allSets[j].memo,
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SetChip extends StatelessWidget {
  const _SetChip({
    required this.order,
    required this.weight,
    required this.reps,
    this.memo,
  });

  final int order;
  final double weight;
  final int reps;
  final String? memo;

  @override
  Widget build(BuildContext context) {
    final label = memo != null && memo!.isNotEmpty
        ? '$order. ${weight}kg×$reps ($memo)'
        : '$order. ${weight}kg×$reps';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white70),
      ),
    );
  }
}
