import 'package:isar/isar.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/core/constants/exercise_catalog.dart';
import 'package:progressive_lift/data/models/custom_exercise_template.dart';
import 'package:progressive_lift/data/models/exercise_record.dart';
import 'package:progressive_lift/data/models/exercise_set.dart';
import 'package:progressive_lift/data/models/workout_session.dart';
import 'package:progressive_lift/domain/models/top_set_point.dart';
import 'package:progressive_lift/domain/services/top_set_extractor.dart';

class DayWorkoutSummary {
  DayWorkoutSummary({required this.date, required this.muscleGroups});

  final DateTime date;
  final Set<MuscleGroup> muscleGroups;
}

class ExerciseHistoryEntry {
  ExerciseHistoryEntry({
    required this.date,
    required this.topSet,
    required this.allSets,
  });

  final DateTime date;
  final TopSetPoint topSet;
  final List<ExerciseSet> allSets;
}

class WorkoutRepository {
  WorkoutRepository(this._isar);

  final Isar _isar;

  static DateTime normalizeDate(DateTime d) =>
      DateTime(d.year, d.month, d.day);

  Future<List<DayWorkoutSummary>> getMonthSummaries(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    return _isar.workoutSessions
        .where()
        .dateBetween(start, end)
        .findAll()
        .then((sessions) async {
      final summaries = <DayWorkoutSummary>[];
      for (final session in sessions) {
        final records = await _isar.exerciseRecords
            .where()
            .sessionIdEqualTo(session.id)
            .findAll();
        final groups = records.map((r) => r.muscleGroup).toSet();
        summaries.add(
          DayWorkoutSummary(
            date: normalizeDate(session.date),
            muscleGroups: groups,
          ),
        );
      }
      return summaries;
    });
  }

  Future<WorkoutSession?> getSessionByDate(DateTime date) {
    final normalized = normalizeDate(date);
    return _isar.workoutSessions
        .where()
        .filter()
        .dateEqualTo(normalized)
        .findFirst();
  }

  Future<WorkoutSession> getOrCreateSession(DateTime date) async {
    final existing = await getSessionByDate(date);
    if (existing != null) return existing;

    final session = WorkoutSession()..date = normalizeDate(date);
    await _isar.writeTxn(() => _isar.workoutSessions.put(session));
    return session;
  }

  Future<List<ExerciseRecord>> getExercisesForSession(int sessionId) {
    return _isar.exerciseRecords
        .where()
        .sessionIdEqualTo(sessionId)
        .findAll();
  }

  Future<List<ExerciseSet>> getSetsForExercise(int exerciseRecordId) {
    return _isar.exerciseSets
        .where()
        .exerciseRecordIdEqualTo(exerciseRecordId)
        .sortBySetOrder()
        .findAll();
  }

  Future<ExerciseRecord> addExercise({
    required int sessionId,
    required String exerciseKey,
    required String name,
    required MuscleGroup muscleGroup,
  }) async {
    final record = ExerciseRecord()
      ..sessionId = sessionId
      ..exerciseKey = exerciseKey
      ..name = name
      ..muscleGroup = muscleGroup;
    await _isar.writeTxn(() => _isar.exerciseRecords.put(record));
    return record;
  }

  Future<ExerciseSet> addSet({
    required int exerciseRecordId,
    required double weightKg,
    required int reps,
  }) async {
    final existing = await getSetsForExercise(exerciseRecordId);
    final set = ExerciseSet()
      ..exerciseRecordId = exerciseRecordId
      ..weightKg = weightKg
      ..reps = reps
      ..setOrder = existing.length;
    await _isar.writeTxn(() => _isar.exerciseSets.put(set));
    return set;
  }

  Future<List<TopSetPoint>> getTopSetSeries(String exerciseKey) async {
    final records = await _isar.exerciseRecords
        .where()
        .exerciseKeyEqualTo(exerciseKey)
        .findAll();

    final setsByDate = <DateTime, List<ExerciseSet>>{};
    final sessionIdsByDate = <DateTime, int>{};
    final recordIdsByDate = <DateTime, int>{};

    for (final record in records) {
      final session = await _isar.workoutSessions.get(record.sessionId);
      if (session == null) continue;
      final day = normalizeDate(session.date);
      final sets = await getSetsForExercise(record.id);
      setsByDate.putIfAbsent(day, () => []).addAll(sets);
      sessionIdsByDate[day] = session.id;
      recordIdsByDate[day] = record.id;
    }

    return TopSetExtractor.buildSeries(
      setsByDate: setsByDate,
      sessionIdsByDate: sessionIdsByDate,
      recordIdsByDate: recordIdsByDate,
    );
  }

  Future<List<ExerciseHistoryEntry>> getExerciseHistory(String exerciseKey) async {
    final records = await _isar.exerciseRecords
        .where()
        .exerciseKeyEqualTo(exerciseKey)
        .findAll();

    final entries = <ExerciseHistoryEntry>[];
    for (final record in records) {
      final session = await _isar.workoutSessions.get(record.sessionId);
      if (session == null) continue;
      final sets = await getSetsForExercise(record.id);
      final top = TopSetExtractor.pickTopSet(sets);
      if (top == null) continue;
      entries.add(
        ExerciseHistoryEntry(
          date: normalizeDate(session.date),
          topSet: TopSetPoint(
            date: normalizeDate(session.date),
            weightKg: top.weightKg,
            reps: top.reps,
          ),
          allSets: sets,
        ),
      );
    }
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  Future<List<CustomExerciseTemplate>> getCustomTemplates() {
    return _isar.customExerciseTemplates.where().sortByCreatedAtDesc().findAll();
  }

  Future<CustomExerciseTemplate> saveCustomTemplate({
    required String name,
    required MuscleGroup muscleGroup,
  }) async {
    final trimmed = name.trim();
    final key = 'custom_${DateTime.now().microsecondsSinceEpoch}';
    final template = CustomExerciseTemplate()
      ..exerciseKey = key
      ..name = trimmed
      ..muscleGroup = muscleGroup
      ..createdAt = DateTime.now();
    await _isar.writeTxn(() => _isar.customExerciseTemplates.put(template));
    return template;
  }

  Future<String> resolveExerciseName(String exerciseKey) async {
    final preset = ExerciseCatalog.findByKey(exerciseKey);
    if (preset != null) return preset.name;

    final custom = await _isar.customExerciseTemplates
        .where()
        .exerciseKeyEqualTo(exerciseKey)
        .findFirst();
    if (custom != null) return custom.name;

    final record = await _isar.exerciseRecords
        .where()
        .exerciseKeyEqualTo(exerciseKey)
        .findFirst();
    return record?.name ?? exerciseKey;
  }
}
