import 'package:isar/isar.dart';

part 'exercise_set.g.dart';

@collection
class ExerciseSet {
  Id id = Isar.autoIncrement;

  /// 親 [ExerciseRecord.id]
  @Index()
  late int exerciseRecordId;

  late double weightKg;
  late int reps;
  late int setOrder;
}
