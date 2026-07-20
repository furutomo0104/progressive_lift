import 'package:flutter/material.dart';
import 'package:progressive_lift/data/models/exercise_set.dart';

class SessionSetComposition extends StatelessWidget {
  const SessionSetComposition({
    super.key,
    required this.sets,
  });

  final List<ExerciseSet> sets;

  static const _barColors = [
    Color(0xFF7986CB),
    Color(0xFF64B5F6),
    Color(0xFF4FC3F7),
    Color(0xFF4DB6AC),
    Color(0xFF81C784),
    Color(0xFFFFB74D),
  ];

  @override
  Widget build(BuildContext context) {
    if (sets.isEmpty) return const SizedBox.shrink();

    final sorted = [...sets]..sort((a, b) => a.setOrder.compareTo(b.setOrder));
    final maxWeight = sorted
        .map((s) => s.weightKg)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < sorted.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _SetBarRow(
              order: i + 1,
              set: sorted[i],
              maxWeight: maxWeight,
              color: _barColors[i % _barColors.length],
            ),
          ),
      ],
    );
  }
}

class _SetBarRow extends StatelessWidget {
  const _SetBarRow({
    required this.order,
    required this.set,
    required this.maxWeight,
    required this.color,
  });

  final int order;
  final ExerciseSet set;
  final double maxWeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ratio = maxWeight > 0 ? (set.weightKg / maxWeight).clamp(0.08, 1.0) : 1.0;
    final weightLabel = set.weightKg % 1 == 0
        ? set.weightKg.toStringAsFixed(0)
        : set.weightKg.toStringAsFixed(1);

    return Row(
      children: [
        SizedBox(
          width: 36,
          child: Text(
            'S$order',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white38,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth * ratio;
              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 22,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: 22,
                    width: barWidth,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${weightLabel}kg × ${set.reps}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: barWidth > 72 ? Colors.white : Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
