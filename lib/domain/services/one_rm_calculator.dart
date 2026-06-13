import 'package:progressive_lift/domain/models/top_set_point.dart';

class OneRmPoint {
  const OneRmPoint({
    required this.date,
    required this.estimatedOneRmKg,
    required this.sourceWeightKg,
    required this.sourceReps,
  });

  final DateTime date;
  final double estimatedOneRmKg;
  final double sourceWeightKg;
  final int sourceReps;
}

/// 推定1RM（Epley式）
class OneRmCalculator {
  static double epley(double weightKg, int reps) {
    if (reps <= 0) return weightKg;
    if (reps == 1) return weightKg;
    return weightKg * (1 + reps / 30);
  }

  static List<OneRmPoint> fromTopSetSeries(List<TopSetPoint> points) {
    return points
        .map(
          (p) => OneRmPoint(
            date: p.date,
            estimatedOneRmKg: epley(p.weightKg, p.reps),
            sourceWeightKg: p.weightKg,
            sourceReps: p.reps,
          ),
        )
        .toList();
  }
}
