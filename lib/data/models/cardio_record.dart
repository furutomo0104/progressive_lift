import 'package:isar/isar.dart';
import 'package:progressive_lift/core/enums/cardio_record_mode.dart';
import 'package:progressive_lift/core/enums/cardio_type.dart';

part 'cardio_record.g.dart';

@collection
class CardioRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late int sessionId;

  @enumerated
  late CardioType type;

  @enumerated
  late CardioRecordMode mode;

  /// 月次集計用。インターバル時はセット構成から自動算出。
  late int durationMinutes;

  int? intervalRounds;
  int? intervalWorkSeconds;
  int? intervalRestSeconds;

  String? memo;
}
