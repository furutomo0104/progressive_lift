import 'package:isar/isar.dart';
import 'package:progressive_lift/core/enums/cardio_type.dart';

part 'cardio_record.g.dart';

@collection
class CardioRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late int sessionId;

  @enumerated
  late CardioType type;

  late int durationMinutes;

  String? memo;
}
