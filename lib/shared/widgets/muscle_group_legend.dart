import 'package:flutter/material.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/shared/widgets/muscle_group_chip.dart';

class MuscleGroupLegend extends StatelessWidget {
  const MuscleGroupLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: MuscleGroup.values
          .map((g) => MuscleGroupChip(group: g, compact: true))
          .toList(),
    );
  }
}
