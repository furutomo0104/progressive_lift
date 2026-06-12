import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:progressive_lift/data/models/custom_exercise_template.dart';
import 'package:progressive_lift/data/local/isar_service.dart';
import 'package:progressive_lift/data/local/seed_data.dart';
import 'package:progressive_lift/data/repositories/workout_repository.dart';
import 'package:progressive_lift/domain/models/selectable_exercise.dart';
import 'package:progressive_lift/domain/models/top_set_point.dart';
import 'package:progressive_lift/domain/services/ai_suggest_service.dart';
import 'package:progressive_lift/domain/services/subscription_service.dart';

part 'app_providers.g.dart';

final isarServiceProvider = Provider<IsarService>((ref) => IsarService());

@Riverpod(keepAlive: true)
Future<Isar> isar(IsarRef ref) async {
  final service = ref.watch(isarServiceProvider);
  final db = await service.db;
  await SeedData.seedIfEmpty(db);
  return db;
}

@Riverpod(keepAlive: true)
Future<WorkoutRepository> workoutRepository(WorkoutRepositoryRef ref) async {
  final db = await ref.watch(isarProvider.future);
  return WorkoutRepository(db);
}

@Riverpod(keepAlive: true)
SubscriptionService subscriptionService(SubscriptionServiceRef ref) {
  return SubscriptionService();
}

@Riverpod(keepAlive: true)
AiSuggestService aiSuggestService(AiSuggestServiceRef ref) {
  return AiSuggestService(ref.watch(subscriptionServiceProvider));
}

@riverpod
class PremiumToggle extends _$PremiumToggle {
  @override
  bool build() => ref.watch(subscriptionServiceProvider).isPremium;

  Future<void> toggle() async {
    final service = ref.read(subscriptionServiceProvider);
    await service.setPremium(!service.isPremium);
    ref.invalidateSelf();
  }
}

@riverpod
Future<List<TopSetPoint>> topSetSeries(TopSetSeriesRef ref, String exerciseKey) {
  return ref.watch(workoutRepositoryProvider.future).then(
        (repo) => repo.getTopSetSeries(exerciseKey),
      );
}

@riverpod
Future<String?> aiSuggestion(AiSuggestionRef ref, String exerciseKey) async {
  final series = await ref.watch(topSetSeriesProvider(exerciseKey).future);
  final ai = ref.watch(aiSuggestServiceProvider);
  return ai.suggestToday(history: series);
}

@riverpod
Future<List<CustomExerciseTemplate>> customExerciseTemplates(
  CustomExerciseTemplatesRef ref,
) async {
  ref.watch(exerciseCatalogTickProvider);
  final repo = await ref.watch(workoutRepositoryProvider.future);
  return repo.getCustomTemplates();
}

@riverpod
class ExerciseCatalogTick extends _$ExerciseCatalogTick {
  @override
  int build() => 0;

  void bump() => state++;
}

@riverpod
Future<List<SelectableExercise>> selectableExercises(
  SelectableExercisesRef ref,
) async {
  ref.watch(exerciseCatalogTickProvider);
  final repo = await ref.watch(workoutRepositoryProvider.future);
  return repo.getSelectableExercises();
}

@riverpod
Future<String> exerciseName(ExerciseNameRef ref, String exerciseKey) async {
  final repo = await ref.watch(workoutRepositoryProvider.future);
  return repo.resolveExerciseName(exerciseKey);
}

/// カレンダー再読み込み用（記録変更時に bump）
@riverpod
class CalendarRefreshTick extends _$CalendarRefreshTick {
  @override
  int build() => 0;

  void bump() => state++;
}

@riverpod
Future<Map<DateTime, DayWorkoutSummary>> calendarSummaries(
  CalendarSummariesRef ref,
  DateTime monthAnchor,
) async {
  ref.watch(calendarRefreshTickProvider);
  final repo = await ref.watch(workoutRepositoryProvider.future);
  final list = await repo.getMonthSummaries(monthAnchor);
  return {
    for (final s in list) WorkoutRepository.normalizeDate(s.date): s,
  };
}
