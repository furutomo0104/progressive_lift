import 'package:isar/isar.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';

part 'exercise_record.g.dart';

@collection
class ExerciseRecord {
  Id id = Isar.autoIncrement;

  /// 親 [WorkoutSession.id]
  @Index()
  late int sessionId;

  /// 種目識別子（例: bench_press）— グラフ集計のキー
  @Index()
  late String exerciseKey;

  late String name;

  @enumerated
  late MuscleGroup muscleGroup;
}
