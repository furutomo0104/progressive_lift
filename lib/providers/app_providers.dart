import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:progressive_lift/data/models/custom_exercise_template.dart';
import 'package:progressive_lift/data/local/isar_service.dart';
import 'package:progressive_lift/data/local/seed_data.dart';
import 'package:progressive_lift/data/repositories/workout_repository.dart';
import 'package:progressive_lift/domain/models/exercise_list_item.dart';
import 'package:progressive_lift/domain/models/month_overload_analysis.dart';
import 'package:progressive_lift/domain/models/month_workout_analysis.dart';
import 'package:progressive_lift/domain/models/selectable_exercise.dart';
import 'package:progressive_lift/domain/models/top_set_point.dart';
import 'package:progressive_lift/domain/services/ai_overload_coach_service.dart';
import 'package:progressive_lift/domain/services/ai_suggest_service.dart';
import 'package:progressive_lift/domain/services/gemini_overload_coach_service.dart';
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
  return SubscriptionService.instance;
}

@riverpod
class ProSubscriptionNotifier extends _$ProSubscriptionNotifier {
  @override
  Future<bool> build() async {
    final service = ref.watch(subscriptionServiceProvider);
    return service.isProUser();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(subscriptionServiceProvider);
      return service.isProUser();
    });
  }

  Future<void> toggleMock() async {
    final current = state.valueOrNull ?? false;
    final service = ref.read(subscriptionServiceProvider);
    service.setMockPro(!current);
    state = AsyncValue.data(!current);
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
  final isPro = await ref.watch(proSubscriptionNotifierProvider.future);
  if (!isPro) return null;
  final series = await ref.watch(topSetSeriesProvider(exerciseKey).future);
  final ai = AiSuggestService();
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

@riverpod
Future<MonthWorkoutAnalysis> monthWorkoutAnalysis(
  MonthWorkoutAnalysisRef ref,
  DateTime monthAnchor,
) async {
  ref.watch(calendarRefreshTickProvider);
  final repo = await ref.watch(workoutRepositoryProvider.future);
  return repo.getMonthAnalysis(monthAnchor);
}

@riverpod
Future<MonthOverloadAnalysis> monthOverloadAnalysis(
  MonthOverloadAnalysisRef ref,
  DateTime monthAnchor,
) async {
  ref.watch(calendarRefreshTickProvider);
  final repo = await ref.watch(workoutRepositoryProvider.future);
  return repo.getMonthOverloadAnalysis(monthAnchor);
}

@riverpod
Future<AiOverloadReport> aiOverloadReport(
  AiOverloadReportRef ref,
  DateTime monthAnchor,
) async {
  final analysis = await ref.watch(monthOverloadAnalysisProvider(monthAnchor).future);
  if (!analysis.hasData) {
    return AiOverloadCoachService.generateReport(analysis);
  }

  // 1. Gemini API Key が設定されている場合は Gemini 1.5 Flash を呼び出し
  if (GeminiOverloadCoachService.hasApiKey) {
    final geminiReport =
        await GeminiOverloadCoachService.generateGeminiReport(analysis);
    if (geminiReport != null) {
      return geminiReport;
    }
  }

  // 2. APIキー未設定時または通信エラー時は高精度ルールベースにフォールバック
  return AiOverloadCoachService.generateReport(analysis);
}

@riverpod
Future<List<ExerciseListItem>> exerciseListItems(ExerciseListItemsRef ref) async {
  ref.watch(calendarRefreshTickProvider);
  ref.watch(exerciseCatalogTickProvider);
  final repo = await ref.watch(workoutRepositoryProvider.future);
  return repo.getExerciseListItems();
}

@riverpod
Future<List<ExerciseHistoryEntry>> exerciseHistory(
  ExerciseHistoryRef ref,
  String exerciseKey,
) async {
  ref.watch(calendarRefreshTickProvider);
  final repo = await ref.watch(workoutRepositoryProvider.future);
  return repo.getExerciseHistory(exerciseKey);
}
