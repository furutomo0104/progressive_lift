import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progressive_lift/domain/models/top_set_point.dart';

/// Case 1: トップセット特化型複合グラフ
/// - 左Y軸: 最高重量（折れ線）
/// - 右Y軸: Reps（棒）
/// - 点線: 直前トップセットの重量（Target）
class TopSetComboChart extends StatelessWidget {
  const TopSetComboChart({
    super.key,
    required this.points,
    this.target,
    this.height = 260,
  });

  final List<TopSetPoint> points;
  final WorkoutTarget? target;
  final double height;

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

    var minW = weights.reduce((a, b) => a < b ? a : b);
    var maxW = weights.reduce((a, b) => a > b ? a : b);
    var minR = reps.reduce((a, b) => a < b ? a : b);
    var maxR = reps.reduce((a, b) => a > b ? a : b);

    if (target != null) {
      minW = [minW, target!.baselineWeightKg, target!.suggestedWeightKg]
          .reduce((a, b) => a < b ? a : b);
      maxW = [maxW, target!.baselineWeightKg, target!.suggestedWeightKg]
          .reduce((a, b) => a > b ? a : b);
    }

    final weightPad = ((maxW - minW) * 0.15).clamp(2.5, 10.0);
    final repsPad = 1.0;
    final minWeightAxis = (minW - weightPad).floorToDouble();
    final maxWeightAxis = (maxW + weightPad).ceilToDouble();
    final minRepsAxis = (minR - repsPad).clamp(0, 20).floorToDouble();
    final maxRepsAxis = (maxR + repsPad + 1).ceilToDouble();

    double mapWeight(double w) => w;
    double mapReps(double r) {
      final rangeW = maxWeightAxis - minWeightAxis;
      final rangeR = maxRepsAxis - minRepsAxis;
      if (rangeR == 0) return minWeightAxis;
      return minWeightAxis + (r - minRepsAxis) / rangeR * rangeW;
    }

    final barGroups = <BarChartGroupData>[];
    final lineSpots = <FlSpot>[];

    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      lineSpots.add(FlSpot(i.toDouble(), mapWeight(p.weightKg)));
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: mapReps(p.reps.toDouble()),
              width: 14,
              color: const Color(0xFF4FC3F7).withValues(alpha: 0.75),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        ),
      );
    }

    final targetY = target != null ? mapWeight(target!.baselineWeightKg) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (target != null) ...[
          Row(
            children: [
              Container(
                width: 24,
                height: 0,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFFFB74D), width: 2),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  target!.displayText,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xFFFFB74D),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Target: ${target!.baselineWeightKg}kg × ${target!.baselineReps}reps',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white54,
                ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          height: height,
          child: Stack(
            children: [
              // 棒グラフ（Reps → 左軸スケールに正規化）
              BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxWeightAxis,
                  minY: minWeightAxis,
                  groupsSpace: 8,
                  barGroups: barGroups,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, meta) {
                          final rangeW = maxWeightAxis - minWeightAxis;
                          final rangeR = maxRepsAxis - minRepsAxis;
                          if (rangeR == 0 || rangeW == 0) return const SizedBox.shrink();
                          final repValue = minRepsAxis +
                              (value - minWeightAxis) / rangeW * rangeR;
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
                        reservedSize: 40,
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
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
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
                  ),
                ),
              ),
              // 折れ線 + ターゲット点線
              LineChart(
                LineChartData(
                  minY: minWeightAxis,
                  maxY: maxWeightAxis,
                  minX: -0.5,
                  maxX: (points.length - 1).toDouble() + 0.5,
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
                  titlesData: const FlTitlesData(show: false),
                  extraLinesData: targetY != null
                      ? ExtraLinesData(
                          horizontalLines: [
                            HorizontalLine(
                              y: targetY,
                              color: const Color(0xFFFFB74D),
                              strokeWidth: 2,
                              dashArray: [6, 4],
                              label: HorizontalLineLabel(
                                show: true,
                                alignment: Alignment.topRight,
                                style: const TextStyle(
                                  color: Color(0xFFFFB74D),
                                  fontSize: 10,
                                ),
                                labelResolver: (_) => 'Target',
                              ),
                            ),
                          ],
                        )
                      : null,
                  lineBarsData: [
                    LineChartBarData(
                      spots: lineSpots,
                      isCurved: false,
                      color: const Color(0xFF7986CB),
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
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
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: const Color(0xFF7986CB), label: 'Max Weight (kg)'),
            const SizedBox(width: 16),
            _LegendDot(color: const Color(0xFF4FC3F7), label: 'Reps'),
          ],
        ),
      ],
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
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white60)),
      ],
    );
  }
}
