import 'package:progressive_lift/core/enums/muscle_group.dart';

/// 種目一覧の共通ソート: 部位順 → カスタム順 → 名前順
int compareMuscleGroupOrder(MuscleGroup a, MuscleGroup b) {
  final ga = MuscleGroup.selectable.indexOf(a);
  final gb = MuscleGroup.selectable.indexOf(b);
  return ga.compareTo(gb);
}

int compareExerciseListOrder({
  required MuscleGroup muscleGroupA,
  required MuscleGroup muscleGroupB,
  required int sortOrderA,
  required int sortOrderB,
  required String nameA,
  required String nameB,
}) {
  final groupCmp = compareMuscleGroupOrder(muscleGroupA, muscleGroupB);
  if (groupCmp != 0) return groupCmp;
  if (sortOrderA != sortOrderB) return sortOrderA.compareTo(sortOrderB);
  return nameA.compareTo(nameB);
}
