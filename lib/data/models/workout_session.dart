import 'package:isar/isar.dart';

part 'workout_session.g.dart';

@collection
class WorkoutSession {
  Id id = Isar.autoIncrement;

  /// 日付のみ（時刻は 00:00:00 に正規化）
  @Index()
  late DateTime date;

  String? memo;
}
