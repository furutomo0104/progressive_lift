import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progressive_lift/domain/models/top_set_point.dart';

/// Case 1: トップセット特化型複合グラフ
/// - 左Y軸: 最高重量（折れ線）
/// - 右Y軸: Reps（棒）
///
/// BarChart + LineChart の Stack は横軸スケールが一致しないため、
/// 単一 LineChart 上で棒を太い縦線として描画する。
class TopSetComboChart extends StatelessWidget {
  const TopSetComboChart({
    super.key,
    required this.points,
    this.height = 260,
  });

  final List<TopSetPoint> points;
  final double height;

  static const _leftAxisReserved = 40.0;
  static const _rightAxisReserved = 36.0;
  static const _bottomAxisReserved = 28.0;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('トップセットの記録がありません')),
      );
    }

    final dateFmt = DateFormat('M/d');
    final weights = points.map((p) => p.weightKg).toList();
    final reps = points.map((p) => p.reps.toDouble()).toList();

    final minW = weights.reduce((a, b) => a < b ? a : b);
    final maxW = weights.reduce((a, b) => a > b ? a : b);
    final minR = reps.reduce((a, b) => a < b ? a : b);
    final maxR = reps.reduce((a, b) => a > b ? a : b);

    final weightPad = ((maxW - minW) * 0.15).clamp(2.5, 10.0);
    const repsPad = 1.0;
    final minWeightAxis = (minW - weightPad).floorToDouble();
    final maxWeightAxis = (maxW + weightPad).ceilToDouble();
    final minRepsAxis = (minR - repsPad).clamp(0, 20).floorToDouble();
    final maxRepsAxis = (maxR + repsPad + 1).ceilToDouble();

    double mapReps(double r) {
      final rangeW = maxWeightAxis - minWeightAxis;
      final rangeR = maxRepsAxis - minRepsAxis;
      if (rangeR == 0) return minWeightAxis;
      return minWeightAxis + (r - minRepsAxis) / rangeR * rangeW;
    }

    final lineSpots = <FlSpot>[];
    final repBarSeries = <LineChartBarData>[];

    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      final x = i.toDouble();
      lineSpots.add(FlSpot(x, p.weightKg));
      repBarSeries.add(
        LineChartBarData(
          spots: [
            FlSpot(x, minWeightAxis),
            FlSpot(x, mapReps(p.reps.toDouble())),
          ],
          isCurved: false,
          color: const Color(0xFF4FC3F7).withValues(alpha: 0.75),
          barWidth: 14,
          isStrokeCapRound: false,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      );
    }

    final weightLineIndex = repBarSeries.length;
    final minX = -0.5;
    final maxX = points.length - 0.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: height,
          child: LineChart(
            LineChartData(
              minY: minWeightAxis,
              maxY: maxWeightAxis,
              minX: minX,
              maxX: maxX,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: weightPad > 5 ? 5 : 2.5,
                getDrawingHorizontalLine: (v) => FlLine(
                  color: Colors.white.withValues(alpha: 0.06),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: _sharedTitlesData(
                points: points,
                dateFmt: dateFmt,
                minWeightAxis: minWeightAxis,
                maxWeightAxis: maxWeightAxis,
                minRepsAxis: minRepsAxis,
                maxRepsAxis: maxRepsAxis,
                showBottom: true,
              ),
              lineBarsData: [
                ...repBarSeries,
                LineChartBarData(
                  spots: lineSpots,
                  isCurved: false,
                  color: const Color(0xFF7986CB),
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) =>
                        FlDotCirclePainter(
                      radius: 4,
                      color: const Color(0xFF7986CB),
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFF7986CB).withValues(alpha: 0.12),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (spots) => spots.map((s) {
                    if (s.barIndex != weightLineIndex) return null;
                    final i = s.x.round();
                    if (i < 0 || i >= points.length) return null;
                    final p = points[i];
                    return LineTooltipItem(
                      '${p.weightKg}kg / ${p.reps}reps',
                      const TextStyle(color: Colors.white, fontSize: 12),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(
              color: const Color(0xFF7986CB),
              label: 'Max Weight (kg)',
            ),
            const SizedBox(width: 16),
            _LegendDot(color: const Color(0xFF4FC3F7), label: 'Reps'),
          ],
        ),
      ],
    );
  }

  static FlTitlesData _sharedTitlesData({
    required List<TopSetPoint> points,
    required DateFormat dateFmt,
    required double minWeightAxis,
    required double maxWeightAxis,
    required double minRepsAxis,
    required double maxRepsAxis,
    required bool showBottom,
  }) {
    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: _rightAxisReserved,
          getTitlesWidget: (value, meta) {
            final rangeW = maxWeightAxis - minWeightAxis;
            final rangeR = maxRepsAxis - minRepsAxis;
            if (rangeR == 0 || rangeW == 0) return const SizedBox.shrink();
            final repValue =
                minRepsAxis + (value - minWeightAxis) / rangeW * rangeR;
            if ((repValue - repValue.round()).abs() > 0.15) {
              return const SizedBox.shrink();
            }
            return Text(
              repValue.round().toString(),
              style: const TextStyle(fontSize: 10, color: Color(0xFF4FC3F7)),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: _leftAxisReserved,
          getTitlesWidget: (value, meta) {
            if ((value - value.roundToDouble()).abs() > 0.01 &&
                (value * 2 - (value * 2).round()).abs() > 0.01) {
              return const SizedBox.shrink();
            }
            return Text(
              value.toStringAsFixed(value % 1 == 0 ? 0 : 1),
              style: const TextStyle(fontSize: 10, color: Colors.white70),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: showBottom,
          reservedSize: _bottomAxisReserved,
          getTitlesWidget: (value, meta) {
            if (!showBottom) return const SizedBox.shrink();
            final i = value.round();
            if (i < 0 || i >= points.length) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                dateFmt.format(points[i].date),
                style: const TextStyle(fontSize: 10, color: Colors.white54),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white60),
        ),
      ],
    );
  }
}
