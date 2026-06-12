import 'package:flutter/material.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';

class MuscleGroupChip extends StatelessWidget {
  const MuscleGroupChip({
    super.key,
    required this.group,
    this.compact = false,
  });

  final MuscleGroup group;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final g = group.displayGroup;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: g.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: g.color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 6 : 8,
            height: compact ? 6 : 8,
            decoration: BoxDecoration(
              color: g.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: compact ? 4 : 6),
          Text(
            g.label,
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              color: g.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
