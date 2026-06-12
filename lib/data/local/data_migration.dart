import 'package:isar/isar.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/data/models/custom_exercise_template.dart';
import 'package:progressive_lift/data/models/exercise_record.dart';
import 'package:progressive_lift/data/models/exercise_set.dart';
import 'package:progressive_lift/data/models/workout_session.dart';

class DataMigration {
  static Future<void> runAll(Isar isar) async {
    await migrateMuscleGroups(isar);
    await migrateRecordedAt(isar);
  }

  static Future<void> migrateMuscleGroups(Isar isar) async {
    await isar.writeTxn(() async {
      final records = await isar.exerciseRecords.where().findAll();
      for (final r in records) {
        if (r.muscleGroup == MuscleGroup.arms) {
          r.muscleGroup = MuscleGroup.biceps;
          await isar.exerciseRecords.put(r);
        }
      }
      final customs = await isar.customExerciseTemplates.where().findAll();
      for (final c in customs) {
        if (c.muscleGroup == MuscleGroup.arms) {
          c.muscleGroup = MuscleGroup.biceps;
          await isar.customExerciseTemplates.put(c);
        }
      }
    });
  }

  static Future<void> migrateRecordedAt(Isar isar) async {
    final sets = await isar.exerciseSets.where().findAll();
    final needsMigration = sets.any((s) => s.recordedAt == null);
    if (!needsMigration) return;

    await isar.writeTxn(() async {
      for (final set in sets) {
        if (set.recordedAt != null) continue;
        final record = await isar.exerciseRecords.get(set.exerciseRecordId);
        if (record == null) {
          set.recordedAt = DateTime.now();
        } else {
          final session = await isar.workoutSessions.get(record.sessionId);
          set.recordedAt = session?.date ?? DateTime.now();
        }
        await isar.exerciseSets.put(set);
      }
    });
  }
}
