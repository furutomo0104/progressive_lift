import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App Store のレビュー依頼（OS 標準ダイアログ）を、記録を終えたタイミングでだけ表示する。
/// OS 側でも年3回までに制限されるため、ここでは表示条件を絞るだけにとどめる。
class ReviewPromptService {
  ReviewPromptService._();
  static final ReviewPromptService instance = ReviewPromptService._();

  static const _prefsLastDayKey = 'review_last_workout_day';
  static const _prefsDayCountKey = 'review_workout_day_count';
  static const _prefsLastRequestKey = 'review_last_request_ms';
  static const _prefsRequestCountKey = 'review_request_count';

  static const minWorkoutDays = 5;
  static const minIntervalBetweenRequests = Duration(days: 120);
  static const maxRequests = 3;

  bool _recordedSinceLastCheck = false;

  static bool get _isFlutterTest =>
      Platform.environment.containsKey('FLUTTER_TEST');

  /// セットを追加したときに呼ぶ。記録した日数（重複なし）を数える。
  Future<void> onSetRecorded() async {
    if (_isFlutterTest) return;
    _recordedSinceLastCheck = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      final dayStamp = '${now.year}-${now.month}-${now.day}';
      if (prefs.getString(_prefsLastDayKey) == dayStamp) return;
      await prefs.setString(_prefsLastDayKey, dayStamp);
      await prefs.setInt(
          _prefsDayCountKey, (prefs.getInt(_prefsDayCountKey) ?? 0) + 1);
    } catch (e) {
      debugPrint('ReviewPromptService onSetRecorded failed: $e');
    }
  }

  /// 記録画面を閉じたときに呼ぶ。条件を満たしたときだけレビュー依頼を出す。
  Future<void> maybeRequestAfterSession() async {
    if (_isFlutterTest || !_recordedSinceLastCheck) return;
    _recordedSinceLastCheck = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final dayCount = prefs.getInt(_prefsDayCountKey) ?? 0;
      final requestCount = prefs.getInt(_prefsRequestCountKey) ?? 0;
      if (dayCount < minWorkoutDays || requestCount >= maxRequests) return;

      final lastMs = prefs.getInt(_prefsLastRequestKey);
      final now = DateTime.now();
      if (lastMs != null &&
          now.difference(DateTime.fromMillisecondsSinceEpoch(lastMs)) <
              minIntervalBetweenRequests) {
        return;
      }

      final review = InAppReview.instance;
      if (!await review.isAvailable()) return;
      await review.requestReview();
      await prefs.setInt(_prefsLastRequestKey, now.millisecondsSinceEpoch);
      await prefs.setInt(_prefsRequestCountKey, requestCount + 1);
    } catch (e) {
      debugPrint('ReviewPromptService maybeRequestAfterSession failed: $e');
    }
  }
}
