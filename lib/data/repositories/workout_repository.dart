import 'package:isar/isar.dart';
import 'package:progressive_lift/core/enums/cardio_record_mode.dart';
import 'package:progressive_lift/core/enums/cardio_type.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/core/constants/exercise_catalog.dart';
import 'package:progressive_lift/core/utils/exercise_list_sort.dart';
import 'package:progressive_lift/data/models/cardio_record.dart';
import 'package:progressive_lift/data/models/custom_exercise_template.dart';
import 'package:progressive_lift/data/models/exercise_preference.dart';
import 'package:progressive_lift/data/models/exercise_record.dart';
import 'package:progressive_lift/data/models/exercise_set.dart';
import 'package:progressive_lift/data/models/workout_session.dart';
import 'package:progressive_lift/domain/models/exercise_list_item.dart';
import 'package:progressive_lift/domain/models/month_overload_analysis.dart';
import 'package:progressive_lift/domain/models/month_workout_analysis.dart';
import 'package:progressive_lift/domain/models/selectable_exercise.dart';
import 'package:progressive_lift/domain/models/top_set_point.dart';
import 'package:progressive_lift/domain/services/one_rm_calculator.dart';
import 'package:progressive_lift/domain/services/top_set_extractor.dart';
import 'package:progressive_lift/domain/services/volume_calculator.dart';

class DayWorkoutSummary {
  DayWorkoutSummary({
    required this.date,
    required this.muscleGroups,
    this.hasCardio = false,
  });

  final DateTime date;
  final Set<MuscleGroup> muscleGroups;
  final bool hasCardio;
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

  Future<MonthWorkoutAnalysis> getMonthAnalysis(DateTime month) async {
    final anchor = DateTime(month.year, month.month, 1);
    final basic = await _computeMonthBasicStats(anchor);
    final prevAnchor = DateTime(anchor.year, anchor.month - 1, 1);
    final prevBasic = await _computeMonthBasicStats(prevAnchor);

    final exerciseKeys = await _exerciseKeysInMonth(anchor);
    final improvements = <MonthProgressHighlight>[];
    final improvedKeys = <String>{};

    for (final key in exerciseKeys) {
      final series = await getTopSetSeries(key);
      if (series.length < 2) continue;

      MonthProgressHighlight? bestInMonth;
      for (var i = 0; i < series.length; i++) {
        final point = series[i];
        if (!_isInMonth(point.date, anchor)) continue;

        final previous = _previousTopSet(series, i);
        if (previous == null) continue;
        if (!_isImprovement(previous, point)) continue;

        improvedKeys.add(key);
        final name = await resolveExerciseName(key);
        final highlight = MonthProgressHighlight(
          exerciseKey: key,
          exerciseName: name,
          previousWeightKg: previous.weightKg,
          previousReps: previous.reps,
          newWeightKg: point.weightKg,
          newReps: point.reps,
        );

        if (bestInMonth == null ||
            _compareHighlights(highlight, bestInMonth) > 0) {
          bestInMonth = highlight;
        }
      }

      if (bestInMonth != null) improvements.add(bestInMonth);
    }

    improvements.sort(_compareHighlights);
    final topHighlights = improvements.take(3).toList();
    final cardioStats = await _computeMonthCardioStats(anchor);

    return MonthWorkoutAnalysis(
      month: anchor,
      trainingDays: basic.trainingDays,
      totalSets: basic.totalSets,
      prExerciseCount: improvedKeys.length,
      muscleGroupSetCounts: basic.muscleGroupSetCounts,
      highlights: topHighlights,
      previousMonthTrainingDays: prevBasic.trainingDays,
      previousMonthTotalSets: prevBasic.totalSets,
      cardioCount: cardioStats.count,
      cardioTotalMinutes: cardioStats.totalMinutes,
    );
  }

  Future<MonthOverloadAnalysis> getMonthOverloadAnalysis(DateTime month) async {
    final anchor = DateTime(month.year, month.month, 1);
    final prevAnchor = DateTime(month.year, month.month - 1, 1);

    final basic = await _computeMonthBasicStats(anchor);
    final exerciseKeys = await _exerciseKeysInMonth(anchor);

    final totalVolume = await _computeMonthTotalVolume(anchor);
    final prevVolume = await _computeMonthTotalVolume(prevAnchor);

    final details = <ExerciseOverloadDetail>[];
    var totalPrCount = 0;
    var overloadedCount = 0;

    for (final key in exerciseKeys) {
      final series = await getTopSetSeries(key);
      if (series.isEmpty) continue;

      final pointsInMonth =
          series.where((p) => _isInMonth(p.date, anchor)).toList();
      if (pointsInMonth.isEmpty) continue;

      final pointsBeforeMonth =
          series.where((p) => p.date.isBefore(anchor)).toList();

      final baselineTop = pointsBeforeMonth.isNotEmpty
          ? pointsBeforeMonth.last
          : pointsInMonth.first;

      // 月内での最高TOP (1RM基準)
      var bestMonthTop = pointsInMonth.first;
      var best1Rm = OneRmCalculator.epley(
        bestMonthTop.weightKg,
        bestMonthTop.reps,
      );

      for (final p in pointsInMonth) {
        final e1rm = OneRmCalculator.epley(p.weightKg, p.reps);
        if (e1rm > best1Rm) {
          best1Rm = e1rm;
          bestMonthTop = p;
        }
      }

      final latestMonthTop = pointsInMonth.last;
      final initial1Rm = OneRmCalculator.epley(
        baselineTop.weightKg,
        baselineTop.reps,
      );

      // PR判定
      var isOverloaded = false;
      for (var i = 0; i < series.length; i++) {
        final p = series[i];
        if (!_isInMonth(p.date, anchor)) continue;
        final prev = _previousTopSet(series, i);
        if (prev != null && _isImprovement(prev, p)) {
          totalPrCount++;
          isOverloaded = true;
        }
      }

      if (!isOverloaded && best1Rm > initial1Rm + 0.1) {
        isOverloaded = true;
      }

      if (isOverloaded) {
        overloadedCount++;
      }

      final isPlateau = pointsInMonth.length >= 2 && !isOverloaded;
      final name = await resolveExerciseName(key);
      final muscle = await _resolveExerciseMuscleGroup(key);

      details.add(
        ExerciseOverloadDetail(
          exerciseKey: key,
          exerciseName: name,
          muscleGroup: muscle,
          baselineTop: baselineTop,
          bestMonthTop: bestMonthTop,
          latestMonthTop: latestMonthTop,
          initialOneRm: initial1Rm,
          bestOneRm: best1Rm,
          sessionCountInMonth: pointsInMonth.length,
          isOverloaded: isOverloaded,
          isPlateau: isPlateau,
        ),
      );
    }

    // 伸び率の高い順にソート
    details.sort((a, b) {
      final cmp = b.oneRmGainPercent.compareTo(a.oneRmGainPercent);
      if (cmp != 0) return cmp;
      return b.oneRmDelta.compareTo(a.oneRmDelta);
    });

    final plateaus = details.where((d) => d.isPlateau).toList();

    return MonthOverloadAnalysis(
      month: anchor,
      totalExercisesTracked: details.length,
      overloadedExercisesCount: overloadedCount,
      totalPrEventsCount: totalPrCount,
      exerciseDetails: details,
      plateauExercises: plateaus,
      muscleGroupSetCounts: basic.muscleGroupSetCounts,
      totalVolumeKg: totalVolume,
      previousMonthVolumeKg: prevVolume > 0 ? prevVolume : null,
    );
  }

  Future<double> _computeMonthTotalVolume(DateTime monthStart) async {
    final start = monthStart;
    final end = DateTime(monthStart.year, monthStart.month + 1, 0, 23, 59, 59);
    final sessions = await _isar.workoutSessions
        .where()
        .dateBetween(start, end)
        .findAll();

    var totalVol = 0.0;
    for (final s in sessions) {
      final exercises = await getExercisesForSession(s.id);
      for (final ex in exercises) {
        final sets = await getSetsForExercise(ex.id);
        for (final set in sets) {
          totalVol += VolumeCalculator.setVolume(set);
        }
      }
    }
    return totalVol;
  }

  Future<MuscleGroup> _resolveExerciseMuscleGroup(String key) async {
    final pref = await getPreferenceForKey(key);
    if (pref != null && pref.hasMuscleGroupOverride) {
      return pref.muscleGroupOverride;
    }
    final custom = await _isar.customExerciseTemplates
        .where()
        .exerciseKeyEqualTo(key)
        .findFirst();
    if (custom != null) {
      return custom.muscleGroup.displayGroup;
    }
    final preset = ExerciseCatalog.findByKey(key);
    return preset?.muscleGroup ?? MuscleGroup.chest;
  }

  Future<({int count, int totalMinutes})> _computeMonthCardioStats(
    DateTime monthStart,
  ) async {
    final start = monthStart;
    final end = DateTime(monthStart.year, monthStart.month + 1, 0, 23, 59, 59);
    final sessions = await _isar.workoutSessions
        .where()
        .dateBetween(start, end)
        .findAll();

    var count = 0;
    var totalMinutes = 0;
    for (final session in sessions) {
      final records = await getCardioForSession(session.id);
      if (records.isEmpty) continue;
      count += records.length;
      for (final r in records) {
        totalMinutes += r.durationMinutes;
      }
    }
    return (count: count, totalMinutes: totalMinutes);
  }

  bool _isInMonth(DateTime date, DateTime monthStart) {
    return date.year == monthStart.year && date.month == monthStart.month;
  }

  TopSetPoint? _previousTopSet(List<TopSetPoint> series, int index) {
    if (index <= 0) return null;
    return series[index - 1];
  }

  bool _isImprovement(TopSetPoint previous, TopSetPoint current) {
    if (current.weightKg > previous.weightKg) return true;
    if (current.weightKg == previous.weightKg && current.reps > previous.reps) {
      return true;
    }
    return false;
  }

  int _compareHighlights(MonthProgressHighlight a, MonthProgressHighlight b) {
    final weightCmp = a.weightDelta.compareTo(b.weightDelta);
    if (weightCmp != 0) return weightCmp;
    return a.repDelta.compareTo(b.repDelta);
  }

  Future<Set<String>> _exerciseKeysInMonth(DateTime monthStart) async {
    final start = monthStart;
    final end = DateTime(monthStart.year, monthStart.month + 1, 0, 23, 59, 59);
    final sessions = await _isar.workoutSessions
        .where()
        .dateBetween(start, end)
        .findAll();
    final keys = <String>{};
    for (final session in sessions) {
      final records = await _isar.exerciseRecords
          .where()
          .sessionIdEqualTo(session.id)
          .findAll();
      for (final record in records) {
        keys.add(record.exerciseKey);
      }
    }
    return keys;
  }

  Future<
      ({
        int trainingDays,
        int totalSets,
        Map<MuscleGroup, int> muscleGroupSetCounts,
      })> _computeMonthBasicStats(DateTime monthStart) async {
    final start = monthStart;
    final end = DateTime(monthStart.year, monthStart.month + 1, 0, 23, 59, 59);
    final sessions = await _isar.workoutSessions
        .where()
        .dateBetween(start, end)
        .findAll();

    var totalSets = 0;
    var trainingDays = 0;
    final muscleGroupSetCounts = <MuscleGroup, int>{};

    for (final session in sessions) {
      final records = await _isar.exerciseRecords
          .where()
          .sessionIdEqualTo(session.id)
          .findAll();

      var sessionSets = 0;

      for (final record in records) {
        final sets = await getSetsForExercise(record.id);
        if (sets.isEmpty) continue;
        sessionSets += sets.length;

        final group = record.muscleGroup.displayGroup;
        if (group.isLegacy) continue;
        muscleGroupSetCounts[group] =
            (muscleGroupSetCounts[group] ?? 0) + sets.length;
      }

      if (sessionSets == 0) continue;

      trainingDays++;
      totalSets += sessionSets;
    }

    return (
      trainingDays: trainingDays,
      totalSets: totalSets,
      muscleGroupSetCounts: muscleGroupSetCounts,
    );
  }

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
        final groups = records
            .map((r) => r.muscleGroup.displayGroup)
            .where((g) => !g.isLegacy)
            .toSet();
        final cardio = await getCardioForSession(session.id);
        summaries.add(
          DayWorkoutSummary(
            date: normalizeDate(session.date),
            muscleGroups: groups,
            hasCardio: cardio.isNotEmpty,
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

  Future<List<ExerciseRecord>> getExercisesForSession(int sessionId) async {
    final records = await _isar.exerciseRecords
        .where()
        .sessionIdEqualTo(sessionId)
        .findAll();
    records.sort((a, b) => a.id.compareTo(b.id));
    return records;
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
    String? memo,
  }) async {
    final existing = await getSetsForExercise(exerciseRecordId);
    final set = ExerciseSet()
      ..exerciseRecordId = exerciseRecordId
      ..weightKg = weightKg
      ..reps = reps
      ..memo = memo?.trim().isEmpty == true ? null : memo?.trim()
      ..recordedAt = DateTime.now()
      ..setOrder = existing.length;
    await _isar.writeTxn(() => _isar.exerciseSets.put(set));
    return set;
  }

  Future<void> updateSet({
    required int setId,
    required int exerciseRecordId,
    required double weightKg,
    required int reps,
    String? memo,
  }) async {
    final set = await _isar.exerciseSets.get(setId);
    if (set == null) return;
    set.weightKg = weightKg;
    set.reps = reps;
    set.memo = memo?.trim().isEmpty == true ? null : memo?.trim();
    await _isar.writeTxn(() => _isar.exerciseSets.put(set));
  }

  Future<void> deleteSet(int setId, int exerciseRecordId) async {
    await _isar.writeTxn(() async {
      await _isar.exerciseSets.delete(setId);
      final remaining = await _isar.exerciseSets
          .where()
          .exerciseRecordIdEqualTo(exerciseRecordId)
          .sortBySetOrder()
          .findAll();
      for (var i = 0; i < remaining.length; i++) {
        remaining[i].setOrder = i;
        await _isar.exerciseSets.put(remaining[i]);
      }
    });
  }

  Future<String?> reassignExerciseRecord({
    required int recordId,
    required String exerciseKey,
    required String name,
    required MuscleGroup muscleGroup,
  }) async {
    final record = await _isar.exerciseRecords.get(recordId);
    if (record == null) return null;
    final oldKey = record.exerciseKey;
    record.exerciseKey = exerciseKey;
    record.name = name;
    record.muscleGroup = muscleGroup;
    await _isar.writeTxn(() => _isar.exerciseRecords.put(record));
    return oldKey;
  }

  Future<void> deleteExercise(int exerciseRecordId) async {
    await _isar.writeTxn(() async {
      final sets = await _isar.exerciseSets
          .where()
          .exerciseRecordIdEqualTo(exerciseRecordId)
          .findAll();
      final setIds = sets.map((s) => s.id).toList();
      if (setIds.isNotEmpty) {
        await _isar.exerciseSets.deleteAll(setIds);
      }
      await _isar.exerciseRecords.delete(exerciseRecordId);
    });
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

  Future<List<ExercisePreference>> getExercisePreferences() {
    return _isar.exercisePreferences.where().findAll();
  }

  Future<ExercisePreference?> getPreferenceForKey(String exerciseKey) {
    return _isar.exercisePreferences
        .where()
        .exerciseKeyEqualTo(exerciseKey)
        .findFirst();
  }

  Future<List<SelectableExercise>> getSelectableExercises() async {
    final prefs = await getExercisePreferences();
    final prefByKey = {for (final p in prefs) p.exerciseKey: p};
    final customs = await getCustomTemplates();
    final customByKey = {for (final c in customs) c.exerciseKey: c};

    final items = <SelectableExercise>[];

    for (final t in ExerciseCatalog.templates) {
      final pref = prefByKey[t.key];
      if (pref?.isHidden == true) continue;
      items.add(
        SelectableExercise(
          exerciseKey: t.key,
          name: pref?.nameOverride ?? t.name,
          muscleGroup: pref != null && pref.hasMuscleGroupOverride
              ? pref.muscleGroupOverride
              : t.muscleGroup,
          isCustom: false,
        ),
      );
    }

    for (final c in customs) {
      items.add(
        SelectableExercise(
          exerciseKey: c.exerciseKey,
          name: c.name,
          muscleGroup: c.muscleGroup.displayGroup,
          isCustom: true,
          customTemplateId: c.id,
        ),
      );
    }

    items.sort(
      (a, b) => compareExerciseListOrder(
        muscleGroupA: a.muscleGroup,
        muscleGroupB: b.muscleGroup,
        sortOrderA: _effectiveSortOrder(
          a,
          prefByKey: prefByKey,
          customByKey: customByKey,
        ),
        sortOrderB: _effectiveSortOrder(
          b,
          prefByKey: prefByKey,
          customByKey: customByKey,
        ),
        nameA: a.name,
        nameB: b.name,
      ),
    );

    return items;
  }

  Future<void> reorderExercises(List<String> exerciseKeysInOrder) async {
    await _isar.writeTxn(() async {
      for (var i = 0; i < exerciseKeysInOrder.length; i++) {
        final key = exerciseKeysInOrder[i];
        final custom = await _isar.customExerciseTemplates
            .where()
            .exerciseKeyEqualTo(key)
            .findFirst();
        if (custom != null) {
          custom.sortOrder = i;
          await _isar.customExerciseTemplates.put(custom);
          continue;
        }

        var pref = await getPreferenceForKey(key);
        if (pref == null) {
          final preset = ExerciseCatalog.findByKey(key);
          pref = ExercisePreference()
            ..exerciseKey = key
            ..muscleGroupOverride = preset?.muscleGroup ?? MuscleGroup.chest
            ..hasMuscleGroupOverride = false;
        }
        pref.sortOrder = i;
        await _isar.exercisePreferences.put(pref);
      }
    });
  }

  int _effectiveSortOrder(
    SelectableExercise exercise, {
    required Map<String, ExercisePreference> prefByKey,
    required Map<String, CustomExerciseTemplate> customByKey,
  }) {
    if (exercise.isCustom) {
      final custom = customByKey[exercise.exerciseKey];
      if (custom != null && custom.sortOrder >= 0) return custom.sortOrder;
      return _defaultCustomSortOrder(custom?.createdAt);
    }

    final pref = prefByKey[exercise.exerciseKey];
    if (pref != null && pref.sortOrder >= 0) return pref.sortOrder;
    return _defaultPresetSortOrder(exercise.exerciseKey);
  }

  int _defaultPresetSortOrder(String exerciseKey) {
    for (var i = 0; i < ExerciseCatalog.templates.length; i++) {
      if (ExerciseCatalog.templates[i].key == exerciseKey) return i;
    }
    return 100000;
  }

  int _defaultCustomSortOrder(DateTime? createdAt) {
    if (createdAt == null) return 200000;
    return 100000 + createdAt.millisecondsSinceEpoch ~/ 1000;
  }

  Future<int> _nextSortOrder() async {
    final prefs = await getExercisePreferences();
    final customs = await getCustomTemplates();
    var maxOrder = -1;
    for (final p in prefs) {
      if (p.sortOrder > maxOrder) maxOrder = p.sortOrder;
    }
    for (final c in customs) {
      if (c.sortOrder > maxOrder) maxOrder = c.sortOrder;
    }
    return maxOrder + 1;
  }

  Future<void> updateCustomTemplate({
    required int id,
    required String name,
    required MuscleGroup muscleGroup,
  }) async {
    final template = await _isar.customExerciseTemplates.get(id);
    if (template == null) return;
    template.name = name.trim();
    template.muscleGroup = muscleGroup;
    await _isar.writeTxn(() => _isar.customExerciseTemplates.put(template));
  }

  Future<void> deleteCustomTemplate(int id) async {
    await _isar.writeTxn(() => _isar.customExerciseTemplates.delete(id));
  }

  Future<void> updatePresetExercise({
    required String exerciseKey,
    required String name,
    required MuscleGroup muscleGroup,
  }) async {
    final preset = ExerciseCatalog.findByKey(exerciseKey);
    if (preset == null) return;

    var pref = await getPreferenceForKey(exerciseKey);
    pref ??= ExercisePreference()..exerciseKey = exerciseKey;

    final trimmed = name.trim();
    pref.nameOverride = trimmed == preset.name ? null : trimmed;
    if (muscleGroup == preset.muscleGroup) {
      pref.hasMuscleGroupOverride = false;
      pref.muscleGroupOverride = preset.muscleGroup;
    } else {
      pref.hasMuscleGroupOverride = true;
      pref.muscleGroupOverride = muscleGroup;
    }
    pref.isHidden = false;

    await _isar.writeTxn(() => _isar.exercisePreferences.put(pref!));
  }

  Future<void> hidePresetExercise(String exerciseKey) async {
    var pref = await getPreferenceForKey(exerciseKey);
    pref ??= ExercisePreference()..exerciseKey = exerciseKey;
    pref.isHidden = true;
    await _isar.writeTxn(() => _isar.exercisePreferences.put(pref!));
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
      ..createdAt = DateTime.now()
      ..sortOrder = await _nextSortOrder();
    await _isar.writeTxn(() => _isar.customExerciseTemplates.put(template));
    return template;
  }

  Future<String> resolveExerciseName(String exerciseKey) async {
    final pref = await getPreferenceForKey(exerciseKey);
    if (pref?.nameOverride != null) return pref!.nameOverride!;

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

  // ── 有酸素 ──

  Future<List<CardioRecord>> getCardioForSession(int sessionId) {
    return _isar.cardioRecords
        .where()
        .sessionIdEqualTo(sessionId)
        .findAll();
  }

  Future<CardioRecord> addCardio({
    required int sessionId,
    required CardioType type,
    required CardioRecordMode mode,
    required int durationMinutes,
    int? intervalRounds,
    int? intervalWorkSeconds,
    int? intervalRestSeconds,
    String? memo,
  }) async {
    final record = CardioRecord()
      ..sessionId = sessionId
      ..type = type
      ..mode = mode
      ..durationMinutes = durationMinutes
      ..intervalRounds = intervalRounds
      ..intervalWorkSeconds = intervalWorkSeconds
      ..intervalRestSeconds = intervalRestSeconds
      ..memo = memo?.trim().isEmpty == true ? null : memo?.trim();
    await _isar.writeTxn(() => _isar.cardioRecords.put(record));
    return record;
  }

  Future<void> updateCardio({
    required int id,
    required CardioType type,
    required CardioRecordMode mode,
    required int durationMinutes,
    int? intervalRounds,
    int? intervalWorkSeconds,
    int? intervalRestSeconds,
    String? memo,
  }) async {
    final record = await _isar.cardioRecords.get(id);
    if (record == null) return;
    record.type = type;
    record.mode = mode;
    record.durationMinutes = durationMinutes;
    record.intervalRounds = intervalRounds;
    record.intervalWorkSeconds = intervalWorkSeconds;
    record.intervalRestSeconds = intervalRestSeconds;
    record.memo = memo?.trim().isEmpty == true ? null : memo?.trim();
    await _isar.writeTxn(() => _isar.cardioRecords.put(record));
  }

  Future<void> deleteCardio(int id) async {
    await _isar.writeTxn(() => _isar.cardioRecords.delete(id));
  }

  // ── 種目一覧（分析タブ用） ──

  Future<List<ExerciseListItem>> getExerciseListItems() async {
    final records = await _isar.exerciseRecords.where().findAll();
    final keys = records.map((r) => r.exerciseKey).toSet();
    final items = <ExerciseListItem>[];

    for (final key in keys) {
      final keyRecords =
          records.where((r) => r.exerciseKey == key).toList();
      ExerciseRecord? latestRecord;
      DateTime? lastDate;

      for (final record in keyRecords) {
        final session = await _isar.workoutSessions.get(record.sessionId);
        if (session == null) continue;
        final day = normalizeDate(session.date);
        if (lastDate == null || day.isAfter(lastDate)) {
          lastDate = day;
          latestRecord = record;
        }
      }

      final series = await getTopSetSeries(key);
      final name = await resolveExerciseName(key);

      items.add(
        ExerciseListItem(
          exerciseKey: key,
          name: name,
          muscleGroup: latestRecord?.muscleGroup.displayGroup ??
              MuscleGroup.chest,
          latestTop: series.isNotEmpty ? series.last : null,
          lastTrainedDate: lastDate,
        ),
      );
    }

    final selectable = await getSelectableExercises();
    final orderIndex = {
      for (var i = 0; i < selectable.length; i++) selectable[i].exerciseKey: i,
    };

    items.sort((a, b) {
      final orderA = orderIndex[a.exerciseKey];
      final orderB = orderIndex[b.exerciseKey];
      return compareExerciseListOrder(
        muscleGroupA: a.muscleGroup,
        muscleGroupB: b.muscleGroup,
        sortOrderA: orderA ?? 100000,
        sortOrderB: orderB ?? 100000,
        nameA: a.name,
        nameB: b.name,
      );
    });
    return items;
  }
}
