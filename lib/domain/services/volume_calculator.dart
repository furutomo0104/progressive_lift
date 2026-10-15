import 'package:progressive_lift/data/models/exercise_set.dart';
import 'package:progressive_lift/data/repositories/workout_repository.dart';
import 'package:progressive_lift/domain/services/top_set_extractor.dart';

class VolumePoint {
  const VolumePoint({
    required this.date,
    required this.totalVolumeKg,
    required this.totalSets,
    required this.totalReps,
    this.topWeightKg,
    this.topReps,
  });

  final DateTime date;
  final double totalVolumeKg;
  final int totalSets;
  final int totalReps;
  final double? topWeightKg;
  final int? topReps;
}

abstract final class VolumeCalculator {
  static double setVolume(ExerciseSet set) => set.weightKg * set.reps;

  static VolumePoint fromSets({
    required DateTime date,
    required List<ExerciseSet> sets,
  }) {
    var volume = 0.0;
    var reps = 0;
    for (final set in sets) {
      volume += setVolume(set);
      reps += set.reps;
    }
    final top = TopSetExtractor.pickTopSet(sets);
    return VolumePoint(
      date: date,
      totalVolumeKg: volume,
      totalSets: sets.length,
      totalReps: reps,
      topWeightKg: top?.weightKg,
      topReps: top?.reps,
    );
  }

  static List<VolumePoint> fromHistory(List<ExerciseHistoryEntry> history) {
    final sorted = [...history]..sort((a, b) => a.date.compareTo(b.date));
    return sorted
        .map(
          (entry) => fromSets(
            date: WorkoutRepository.normalizeDate(entry.date),
            sets: entry.allSets,
          ),
        )
        .toList();
  }
}
