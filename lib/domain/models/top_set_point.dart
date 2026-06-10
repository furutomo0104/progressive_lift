/// 1日1種目あたりのトップセット（グラフプロット用）
class TopSetPoint {
  const TopSetPoint({
    required this.date,
    required this.weightKg,
    required this.reps,
    this.sessionId,
    this.exerciseRecordId,
  });

  final DateTime date;
  final double weightKg;
  final int reps;
  final int? sessionId;
  final int? exerciseRecordId;

  String get label => '${weightKg}kg × $reps';
}

/// 直前トップセットに基づく今日の目標
class WorkoutTarget {
  const WorkoutTarget({
    required this.baselineWeightKg,
    required this.baselineReps,
    required this.suggestedWeightKg,
    required this.suggestedMinReps,
    required this.displayText,
  });

  final double baselineWeightKg;
  final int baselineReps;
  final double suggestedWeightKg;
  final int suggestedMinReps;
  final String displayText;
}
