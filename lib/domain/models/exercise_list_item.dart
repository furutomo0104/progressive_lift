import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/domain/models/top_set_point.dart';

class ExerciseListItem {
  const ExerciseListItem({
    required this.exerciseKey,
    required this.name,
    required this.muscleGroup,
    this.latestTop,
    this.lastTrainedDate,
  });

  final String exerciseKey;
  final String name;
  final MuscleGroup muscleGroup;
  final TopSetPoint? latestTop;
  final DateTime? lastTrainedDate;
}
