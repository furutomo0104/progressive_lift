import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:progressive_lift/data/models/exercise_record.dart';
import 'package:progressive_lift/data/models/exercise_set.dart';
import 'package:progressive_lift/features/workout/presentation/add_exercise_sheet.dart';
import 'package:progressive_lift/features/workout/presentation/exercise_card.dart';
import 'package:progressive_lift/providers/app_providers.dart';

class WorkoutRecordPanel extends HookConsumerWidget {
  const WorkoutRecordPanel({super.key, required this.selectedDay});

  final DateTime selectedDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repoAsync = ref.watch(workoutRepositoryProvider);
    final refresh = useState(0);

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
            onChanged: () => refresh.value++,
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
    return _DayData(
      session: session,
      exercises: exercises,
      setsByExercise: setsMap,
    );
  }
}

class _DayData {
  _DayData({
    required this.session,
    required this.exercises,
    required this.setsByExercise,
  });

  final dynamic session;
  final List<ExerciseRecord> exercises;
  final Map<int, List<ExerciseSet>> setsByExercise;
}

class _WorkoutRecordBody extends HookConsumerWidget {
  const _WorkoutRecordBody({
    required this.selectedDay,
    required this.session,
    required this.exercises,
    required this.setsByExercise,
    required this.onChanged,
  });

  final DateTime selectedDay;
  final dynamic session;
  final List<ExerciseRecord> exercises;
  final Map<int, List<ExerciseSet>> setsByExercise;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedId = useState<int?>(null);

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
      expandedId.value = record.id;
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
          child: exercises.isEmpty
              ? _EmptyState(onAdd: openAddExercise)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: exercises.length,
                  itemBuilder: (_, i) {
                    final ex = exercises[i];
                    return ExerciseCard(
                      exercise: ex,
                      sets: setsByExercise[ex.id] ?? [],
                      expanded: expandedId.value == ex.id,
                      onToggle: () => expandedId.value =
                          expandedId.value == ex.id ? null : ex.id,
                      onSetAdded: onChanged,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.fitness_center,
              size: 48,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            const Text(
              '種目を追加して\nセットを記録しましょう',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 15),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('最初の種目を追加'),
            ),
          ],
        ),
      ),
    );
  }
}
