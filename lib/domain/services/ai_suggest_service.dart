import 'package:progressive_lift/domain/models/top_set_point.dart';
import 'package:progressive_lift/domain/services/subscription_service.dart';
import 'package:progressive_lift/domain/services/top_set_extractor.dart';

/// 将来のAIサジェスト機能スタブ（プレミアム限定）
class AiSuggestService {
  AiSuggestService(this._subscription);

  final SubscriptionService _subscription;

  Future<String?> suggestToday({
    required List<TopSetPoint> history,
  }) async {
    if (!_subscription.canUseAiSuggest()) {
      return null;
    }
    if (history.length < 2) {
      return 'データが増えると、AIが最適な重量・回数を提案します。';
    }

    final last = history.last;
    final prev = history[history.length - 2];
    final weightDelta = last.weightKg - prev.weightKg;
    final repsDelta = last.reps - prev.reps;

    // 傾きの簡易スタブ（線形トレンドの代用）
    final trendWeight = weightDelta > 0 ? 2.5 : (weightDelta < 0 ? 0.0 : 2.5);
    final targetWeight =
        TopSetExtractor.buildTarget(last)?.suggestedWeightKg ?? last.weightKg + trendWeight;
    final targetReps = (last.reps + (repsDelta >= 0 ? 0 : 1)).clamp(3, 8);

    return '今日は$targetWeight kgで$targetReps 回に挑戦しましょう';
  }
}
