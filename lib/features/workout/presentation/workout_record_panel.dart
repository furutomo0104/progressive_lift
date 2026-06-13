import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:progressive_lift/data/models/cardio_record.dart';
import 'package:progressive_lift/data/models/exercise_record.dart';
import 'package:progressive_lift/data/models/exercise_set.dart';
import 'package:progressive_lift/features/workout/presentation/add_exercise_sheet.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:progressive_lift/features/workout/presentation/cardio_section.dart';
import 'package:progressive_lift/features/workout/presentation/exercise_card.dart';
import 'package:progressive_lift/providers/app_providers.dart';

class WorkoutRecordPanel extends HookConsumerWidget {
  const WorkoutRecordPanel({super.key, required this.selectedDay});

  final DateTime selectedDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repoAsync = ref.watch(workoutRepositoryProvider);
    final refresh = useState(0);
    final expandedId = useState<int?>(null);

    return repoAsync.when(
      data: (repo) => FutureBuilder(
        key: ValueKey('${selectedDay.toIso8601String()}_${refresh.value}'),
        future: _loadDay(repo, selectedDay),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return _WorkoutRecordBody(
            selectedDay: selectedDay,
            session: data.session,
            exercises: data.exercises,
            setsByExercise: data.setsByExercise,
            cardioRecords: data.cardioRecords,
            expandedId: expandedId.value,
            onExpandedChanged: (id) => expandedId.value = id,
            onChanged: () {
              ref.read(calendarRefreshTickProvider.notifier).bump();
              refresh.value++;
            },
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('エラー: $e')),
    );
  }

  static Future<_DayData> _loadDay(dynamic repo, DateTime day) async {
    final session = await repo.getOrCreateSession(day);
    final exercises = await repo.getExercisesForSession(session.id);
    final setsMap = <int, List<ExerciseSet>>{};
    for (final ex in exercises) {
      setsMap[ex.id] = await repo.getSetsForExercise(ex.id);
    }
    final cardio = await repo.getCardioForSession(session.id);
    return _DayData(
      session: session,
      exercises: exercises,
      setsByExercise: setsMap,
      cardioRecords: cardio,
    );
  }
}

class _DayData {
  _DayData({
    required this.session,
    required this.exercises,
    required this.setsByExercise,
    required this.cardioRecords,
  });

  final dynamic session;
  final List<ExerciseRecord> exercises;
  final Map<int, List<ExerciseSet>> setsByExercise;
  final List<CardioRecord> cardioRecords;
}

class _WorkoutRecordBody extends HookConsumerWidget {
  const _WorkoutRecordBody({
    required this.selectedDay,
    required this.session,
    required this.exercises,
    required this.setsByExercise,
    required this.cardioRecords,
    required this.expandedId,
    required this.onExpandedChanged,
    required this.onChanged,
  });

  final DateTime selectedDay;
  final dynamic session;
  final List<ExerciseRecord> exercises;
  final Map<int, List<ExerciseSet>> setsByExercise;
  final List<CardioRecord> cardioRecords;
  final int? expandedId;
  final ValueChanged<int?> onExpandedChanged;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> openAddExercise() async {
      final result = await showAddExerciseSheet(context);
      if (result == null) return;
      final repo = await ref.read(workoutRepositoryProvider.future);
      final record = await repo.addExercise(
        sessionId: session.id as int,
        exerciseKey: result.exerciseKey,
        name: result.name,
        muscleGroup: result.muscleGroup,
      );
      onExpandedChanged(record.id);
      onChanged();
    }

    final dateLabel = DateFormat('M月d日(E)', 'ja').format(selectedDay);
    final totalSets = setsByExercise.values.fold<int>(
      0,
      (sum, sets) => sum + sets.length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (exercises.isNotEmpty)
                      Text(
                        '${exercises.length}種目 · $totalSetsセット',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: openAddExercise,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('種目追加'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: SlidableAutoCloseBehavior(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                if (exercises.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 40,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '種目を追加してセットを記録',
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: openAddExercise,
                          icon: const Icon(Icons.add),
                          label: const Text('最初の種目を追加'),
                        ),
                      ],
                    ),
                  )
                else
                  ...exercises.map(
                    (ex) => ExerciseCard(
                      key: ValueKey('exercise-card-${ex.id}'),
                      exercise: ex,
                      sets: setsByExercise[ex.id] ?? [],
                      expanded: expandedId == ex.id,
                      onToggle: () => onExpandedChanged(
                        expandedId == ex.id ? null : ex.id,
                      ),
                      onChanged: () {
                        if (!exercises.any((e) => e.id == expandedId)) {
                          onExpandedChanged(null);
                        }
                        onChanged();
                      },
                    ),
                  ),
                CardioSection(
                  sessionId: session.id as int,
                  records: cardioRecords,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
