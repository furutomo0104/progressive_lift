import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/domain/models/top_set_point.dart';

class ExerciseOverloadDetail {
  const ExerciseOverloadDetail({
    required this.exerciseKey,
    required this.exerciseName,
    required this.muscleGroup,
    required this.baselineTop,
    required this.bestMonthTop,
    required this.latestMonthTop,
    required this.initialOneRm,
    required this.bestOneRm,
    required this.sessionCountInMonth,
    required this.isOverloaded,
    required this.isPlateau,
  });

  final String exerciseKey;
  final String exerciseName;
  final MuscleGroup muscleGroup;
  final TopSetPoint? baselineTop;
  final TopSetPoint? bestMonthTop;
  final TopSetPoint? latestMonthTop;
  final double initialOneRm;
  final double bestOneRm;
  final int sessionCountInMonth;
  final bool isOverloaded;
  final bool isPlateau;

  double get oneRmDelta => bestOneRm - initialOneRm;
  double get oneRmGainPercent =>
      initialOneRm > 0 ? (oneRmDelta / initialOneRm) * 100 : 0.0;

  double get weightDelta {
    if (bestMonthTop == null || baselineTop == null) return 0.0;
    return bestMonthTop!.weightKg - baselineTop!.weightKg;
  }

  int get repDelta {
    if (bestMonthTop == null || baselineTop == null) return 0;
    return bestMonthTop!.reps - baselineTop!.reps;
  }
}

class MonthOverloadAnalysis {
  const MonthOverloadAnalysis({
    required this.month,
    required this.totalExercisesTracked,
    required this.overloadedExercisesCount,
    required this.totalPrEventsCount,
    required this.exerciseDetails,
    required this.plateauExercises,
    required this.muscleGroupSetCounts,
    required this.totalVolumeKg,
    this.previousMonthVolumeKg,
  });

  final DateTime month;
  final int totalExercisesTracked;
  final int overloadedExercisesCount;
  final int totalPrEventsCount;
  final List<ExerciseOverloadDetail> exerciseDetails;
  final List<ExerciseOverloadDetail> plateauExercises;
  final Map<MuscleGroup, int> muscleGroupSetCounts;
  final double totalVolumeKg;
  final double? previousMonthVolumeKg;

  bool get hasData => totalExercisesTracked > 0;

  double get overloadRate => totalExercisesTracked > 0
      ? (overloadedExercisesCount / totalExercisesTracked) * 100
      : 0.0;

  double? get volumeDeltaPercent {
    if (previousMonthVolumeKg == null || previousMonthVolumeKg! <= 0) {
      return null;
    }
    return ((totalVolumeKg - previousMonthVolumeKg!) /
            previousMonthVolumeKg!) *
        100;
  }
}
