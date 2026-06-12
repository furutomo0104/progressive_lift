import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progressive_lift/data/models/custom_exercise_template.dart';
import 'package:progressive_lift/data/models/exercise_preference.dart';
import 'package:progressive_lift/data/models/exercise_record.dart';
import 'package:progressive_lift/data/models/exercise_set.dart';
import 'package:progressive_lift/data/local/data_migration.dart';
import 'package:progressive_lift/data/models/workout_session.dart';

class IsarService {
  Isar? _isar;

  Future<Isar> get db async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        WorkoutSessionSchema,
        ExerciseRecordSchema,
        ExerciseSetSchema,
        CustomExerciseTemplateSchema,
        ExercisePreferenceSchema,
      ],
      directory: dir.path,
    );
    await DataMigration.runAll(_isar!);
    return _isar!;
  }

  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
