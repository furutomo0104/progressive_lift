import 'package:progressive_lift/core/enums/cardio_record_mode.dart';
import 'package:progressive_lift/data/models/cardio_record.dart';

extension CardioRecordSummary on CardioRecord {
  bool get isInterval =>
      mode == CardioRecordMode.interval &&
      intervalRounds != null &&
      intervalWorkSeconds != null &&
      intervalRestSeconds != null;

  String get detailLabel {
    if (isInterval) {
      return '$intervalRoundsセット '
          '($intervalWorkSeconds秒/$intervalRestSeconds秒) · 約${durationMinutes}分';
    }
    return '$durationMinutes分';
  }
}
