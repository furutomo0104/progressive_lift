import 'package:progressive_lift/data/models/exercise_set.dart';
import 'package:progressive_lift/domain/models/top_set_point.dart';

/// トップセット抽出と時系列データ生成
class TopSetExtractor {
  /// その日の全セットからトップセットを1つ抽出
  /// ルール: 最高重量 → 同重量なら最大Rep
  static ExerciseSet? pickTopSet(List<ExerciseSet> sets) {
    if (sets.isEmpty) return null;

    ExerciseSet best = sets.first;
    for (final set in sets.skip(1)) {
      if (set.weightKg > best.weightKg) {
        best = set;
      } else if (set.weightKg == best.weightKg && set.reps > best.reps) {
        best = set;
      }
    }
    return best;
  }

  /// 日付ごとにグループ化されたセットからトップセット系列を生成
  static List<TopSetPoint> buildSeries({
    required Map<DateTime, List<ExerciseSet>> setsByDate,
    Map<DateTime, int>? sessionIdsByDate,
    Map<DateTime, int>? recordIdsByDate,
  }) {
    final dates = setsByDate.keys.toList()..sort();
    final points = <TopSetPoint>[];

    for (final date in dates) {
      final top = pickTopSet(setsByDate[date]!);
      if (top == null) continue;
      points.add(
        TopSetPoint(
          date: date,
          weightKg: top.weightKg,
          reps: top.reps,
          sessionId: sessionIdsByDate?[date],
          exerciseRecordId: recordIdsByDate?[date],
        ),
      );
    }
    return points;
  }

  /// 直近（前回）トップセットを基準に今日の目標を算出
  static WorkoutTarget? buildTarget(TopSetPoint? previousTop) {
    if (previousTop == null) return null;

    final suggestedWeight = _roundToPlate(previousTop.weightKg + 2.5);
    final suggestedReps = (previousTop.reps - 1).clamp(1, 12);

    return WorkoutTarget(
      baselineWeightKg: previousTop.weightKg,
      baselineReps: previousTop.reps,
      suggestedWeightKg: suggestedWeight,
      suggestedMinReps: suggestedReps,
      displayText:
          '今日の目標: ${suggestedWeight}kg × ${suggestedReps}reps以上',
    );
  }

  static double _roundToPlate(double kg) {
    return (kg * 2).round() / 2;
  }
}
