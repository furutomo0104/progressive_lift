import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

const chartWeightColor = Color(0xFF7986CB);
const chartRepsColor = Color(0xFF4FC3F7);

/// 日付ラベルを何件おきに出すか
int chartDateLabelStep(int length) => length <= 8
    ? 1
    : length <= 16
        ? 2
        : length <= 30
            ? 3
            : 5;

/// 端点は必ず表示し、途中は [chartDateLabelStep] おきに表示する
bool chartShowsDateLabel(int index, int length) {
  if (index == 0 || index == length - 1) return true;
  return index % chartDateLabelStep(length) == 0;
}

/// タップ／長押しで選ばれた点のインデックス。対象外のイベントなら null。
int? chartTouchedIndex(
  FlTouchEvent event,
  LineTouchResponse? response,
  int length,
) {
  if (event is! FlTapUpEvent &&
      event is! FlLongPressStart &&
      event is! FlLongPressMoveUpdate) {
    return null;
  }
  final spots = response?.lineBarSpots;
  if (spots == null || spots.isEmpty) return null;
  final i = spots.first.x.round();
  if (i < 0 || i >= length) return null;
  return i;
}

/// グラフ上部に固定表示する「日付・トップセット」。未選択時は最新を表示。
class ChartPointReadout extends StatelessWidget {
  const ChartPointReadout({
    super.key,
    required this.date,
    required this.weightKg,
    required this.reps,
    required this.isDefault,
    this.metric,
  });

  final DateTime date;
  final double? weightKg;
  final int? reps;
  final bool isDefault;

  /// グラフ固有の値（例: 「1RM 98.7kg」）
  final String? metric;

  static const _weekdays = ['月', '火', '水', '木', '金', '土', '日'];

  static String formatWeight(double w) =>
      w % 1 == 0 ? w.toStringAsFixed(0) : w.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    const valueStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    final dateLabel =
        '${date.month}/${date.day}(${_weekdays[date.weekday - 1]})';
    final w = weightKg;
    final r = reps;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              isDefault ? '最新 $dateLabel' : dateLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: isDefault ? Colors.white54 : Colors.white,
                fontWeight: isDefault ? FontWeight.normal : FontWeight.w600,
              ),
            ),
          ),
          if (metric != null) ...[
            Text(
              metric!,
              style: const TextStyle(fontSize: 12, color: Colors.white54),
            ),
            const SizedBox(width: 10),
          ],
          if (w != null && r != null) ...[
            Text(
              '${formatWeight(w)}kg',
              style: valueStyle.copyWith(color: chartWeightColor),
            ),
            const Text(
              ' × ',
              style: TextStyle(fontSize: 14, color: Colors.white38),
            ),
            Text(
              '$r回',
              style: valueStyle.copyWith(color: chartRepsColor),
            ),
          ],
        ],
      ),
    );
  }
}
