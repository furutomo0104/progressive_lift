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

  /// 補助・パーシャル・Failed 等のメモ
  String? memo;

  /// セットを記録した日時
  DateTime? recordedAt;
}
