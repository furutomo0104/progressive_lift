import 'package:flutter/material.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';

/// カレンダー日付セル用の部位ドット表示
class MuscleGroupDots extends StatelessWidget {
  const MuscleGroupDots({
    super.key,
    required this.groups,
    this.dotSize = 7,
    this.maxVisible = 4,
  });

  final Set<MuscleGroup> groups;
  final double dotSize;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return SizedBox(height: dotSize + 2);
    }

    final sorted = MuscleGroup.values.where(groups.contains).toList();
    final visible = sorted.take(maxVisible).toList();
    final overflow = sorted.length - visible.length;
    final multiPart = sorted.length >= 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (multiPart)
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${sorted.length}部位',
              style: const TextStyle(fontSize: 7, color: Colors.white70),
            ),
          ),
        SizedBox(
          height: dotSize + 2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...visible.map((g) => _Dot(color: g.color, size: dotSize)),
              if (overflow > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    '+$overflow',
                    style: const TextStyle(fontSize: 8, color: Colors.white54),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 3,
          ),
        ],
      ),
    );
  }
}
