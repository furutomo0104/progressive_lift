import 'package:isar/isar.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/data/models/exercise_record.dart';
import 'package:progressive_lift/data/models/exercise_set.dart';
import 'package:progressive_lift/data/models/workout_session.dart';

/// 初回起動時のデモデータ（ベンチプレスの漸進性過負荷）
class SeedData {
  static Future<void> seedIfEmpty(Isar isar) async {
    final count = await isar.workoutSessions.count();
    if (count > 0) return;

    final benchHistory = <List<(double, int)>>[
      [(80, 8), (80, 7), (75, 10)],
      [(82.5, 7), (82.5, 6), (80, 8)],
      [(85, 6), (85, 5), (82.5, 7)],
      [(87.5, 6), (87.5, 5), (85, 6)],
      [(90, 5), (90, 4), (87.5, 6)],
      [(92.5, 5), (92.5, 4), (90, 5)],
      [(95, 5), (95, 4), (92.5, 5)],
      [(97.5, 4), (97.5, 4), (95, 5)],
      [(100, 5), (100, 4), (97.5, 4)],
      [(102.5, 5), (102.5, 4), (100, 4)],
    ];

    await isar.writeTxn(() async {
      final now = DateTime.now();
      for (var i = 0; i < benchHistory.length; i++) {
        final day = DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: (benchHistory.length - i) * 4));

        final session = WorkoutSession()
          ..date = day
          ..memo = null;
        await isar.workoutSessions.put(session);

        final record = ExerciseRecord()
          ..sessionId = session.id
          ..exerciseKey = 'bench_press'
          ..name = 'ベンチプレス'
          ..muscleGroup = MuscleGroup.chest;
        await isar.exerciseRecords.put(record);

        var order = 0;
        for (final (w, r) in benchHistory[i]) {
          final set = ExerciseSet()
            ..exerciseRecordId = record.id
            ..weightKg = w
            ..reps = r
            ..setOrder = order++;
          await isar.exerciseSets.put(set);
        }

        // 脚の日を散りばめる
        if (i % 3 == 0) {
          final legSession = WorkoutSession()..date = day.add(const Duration(days: 1));
          await isar.workoutSessions.put(legSession);
          final squat = ExerciseRecord()
            ..sessionId = legSession.id
            ..exerciseKey = 'squat'
            ..name = 'スクワット'
            ..muscleGroup = MuscleGroup.legs;
          await isar.exerciseRecords.put(squat);
          for (var s = 0; s < 3; s++) {
            await isar.exerciseSets.put(
              ExerciseSet()
                ..exerciseRecordId = squat.id
                ..weightKg = 100 + i * 2.5
                ..reps = 6 - s
                ..setOrder = s,
            );
          }
        }
      }
    });
  }
}
