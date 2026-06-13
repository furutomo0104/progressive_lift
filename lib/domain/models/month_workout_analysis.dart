import 'package:progressive_lift/core/enums/muscle_group.dart';

class MonthProgressHighlight {
  const MonthProgressHighlight({
    required this.exerciseKey,
    required this.exerciseName,
    required this.previousWeightKg,
    required this.previousReps,
    required this.newWeightKg,
    required this.newReps,
  });

  final String exerciseKey;
  final String exerciseName;
  final double previousWeightKg;
  final int previousReps;
  final double newWeightKg;
  final int newReps;

  double get weightDelta => newWeightKg - previousWeightKg;
  int get repDelta => newReps - previousReps;
}

class MonthWorkoutAnalysis {
  const MonthWorkoutAnalysis({
    required this.month,
    required this.trainingDays,
    required this.totalSets,
    required this.prExerciseCount,
    required this.muscleGroupSetCounts,
    required this.highlights,
    this.previousMonthTrainingDays,
    this.previousMonthTotalSets,
    this.cardioCount = 0,
    this.cardioTotalMinutes = 0,
  });

  final DateTime month;
  final int trainingDays;
  final int totalSets;
  final int prExerciseCount;
  final Map<MuscleGroup, int> muscleGroupSetCounts;
  final List<MonthProgressHighlight> highlights;
  final int? previousMonthTrainingDays;
  final int? previousMonthTotalSets;
  final int cardioCount;
  final int cardioTotalMinutes;

  bool get hasData => trainingDays > 0;

  bool get hasCardioData => cardioCount > 0;

  int? get trainingDaysDelta => previousMonthTrainingDays != null
      ? trainingDays - previousMonthTrainingDays!
      : null;

  int? get totalSetsDelta =>
      previousMonthTotalSets != null ? totalSets - previousMonthTotalSets! : null;
}
