import 'package:progressive_lift/core/enums/muscle_group.dart';

class SelectableExercise {
  const SelectableExercise({
    required this.exerciseKey,
    required this.name,
    required this.muscleGroup,
    required this.isCustom,
    this.customTemplateId,
  });

  final String exerciseKey;
  final String name;
  final MuscleGroup muscleGroup;
  final bool isCustom;
  final int? customTemplateId;
}
