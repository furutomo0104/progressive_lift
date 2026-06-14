import 'package:isar/isar.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';

part 'custom_exercise_template.g.dart';

@collection
class CustomExerciseTemplate {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String exerciseKey;

  late String name;

  @enumerated
  late MuscleGroup muscleGroup;

  @Index()
  late DateTime createdAt;

  /// 一覧表示順（-1 = デフォルト順）
  int sortOrder = -1;
}
