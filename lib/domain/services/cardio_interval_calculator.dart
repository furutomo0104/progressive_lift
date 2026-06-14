/// インターバル記録の合計時間を算出する。
abstract final class CardioIntervalCalculator {
  static int totalSeconds({
    required int rounds,
    required int workSeconds,
    required int restSeconds,
  }) {
    if (rounds <= 0 || workSeconds <= 0) return 0;
    final rest = restSeconds.clamp(0, 9999);
    return rounds * workSeconds + (rounds - 1) * rest;
  }

  static int totalMinutesCeil({
    required int rounds,
    required int workSeconds,
    required int restSeconds,
  }) {
    final seconds = totalSeconds(
      rounds: rounds,
      workSeconds: workSeconds,
      restSeconds: restSeconds,
    );
    if (seconds <= 0) return 0;
    return (seconds / 60).ceil();
  }
}
