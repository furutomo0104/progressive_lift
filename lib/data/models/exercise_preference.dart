import 'package:isar/isar.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';

part 'exercise_preference.g.dart';

/// デフォルト種目の名前・部位の上書き、一覧からの非表示
@collection
class ExercisePreference {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String exerciseKey;

  String? nameOverride;

  bool hasMuscleGroupOverride = false;

  @enumerated
  late MuscleGroup muscleGroupOverride;

  bool isHidden = false;
}
