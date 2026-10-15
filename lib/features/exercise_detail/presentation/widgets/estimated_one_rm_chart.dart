import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:progressive_lift/domain/services/one_rm_calculator.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/widgets/chart_point_readout.dart';

const _lineColor = Color(0xFF9575CD);

class EstimatedOneRmChart extends StatefulWidget {
  const EstimatedOneRmChart({
    super.key,
    required this.points,
    this.height = 260,
  });

  final List<OneRmPoint> points;
  final double height;

  @override
  State<EstimatedOneRmChart> createState() => _EstimatedOneRmChartState();
}

class _EstimatedOneRmChartState extends State<EstimatedOneRmChart> {
  int? _selectedIndex;

  List<OneRmPoint> get points => widget.points;

  @override
  void didUpdateWidget(covariant EstimatedOneRmChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    final selected = _selectedIndex;
    if (selected != null && selected >= points.length) {
      _selectedIndex = null;
    }
  }

  void _handleTouch(FlTouchEvent event, LineTouchResponse? response) {
    final i = chartTouchedIndex(event, response, points.length);
    if (i == null || i == _selectedIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedIndex = i);
  }

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('推定1RMの記録がありません')),
      );
    }

    final values = points.map((p) => p.estimatedOneRmKg).toList();
    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final pad = ((maxV - minV) * 0.15).clamp(2.5, 10.0);
    final minY = (minV - pad).floorToDouble();
    final maxY = (maxV + pad).ceilToDouble();
    final dateFmt = DateFormat('M/d');
    final selected = _selectedIndex;
    final shown = points[selected ?? points.length - 1];

    final spots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].estimatedOneRmKg),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChartPointReadout(
          date: shown.date,
          weightKg: shown.sourceWeightKg,
          reps: shown.sourceReps,
          isDefault: selected == null,
          metric: '1RM ${shown.estimatedOneRmKg.toStringAsFixed(1)}kg',
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: widget.height,
          child: LineChart(
            LineChartData(
              minX: -0.5,
              maxX: points.length - 0.5,
              minY: minY,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (v) => FlLine(
                  color: Colors.white.withValues(alpha: 0.06),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      if ((value - value.roundToDouble()).abs() > 0.01) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        value.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final i = value.round();
                      if (i < 0 ||
                          i >= points.length ||
                          !chartShowsDateLabel(i, points.length)) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          dateFmt.format(points[i].date),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white54,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              extraLinesData: ExtraLinesData(
                verticalLines: [
                  if (selected != null)
                    VerticalLine(
                      x: selected.toDouble(),
                      color: Colors.white38,
                      strokeWidth: 1,
                      dashArray: const [4, 3],
                    ),
                ],
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: _lineColor,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) =>
                        index == selected
                            ? FlDotCirclePainter(
                                radius: 6,
                                color: Colors.white,
                                strokeWidth: 3,
                                strokeColor: _lineColor,
                              )
                            : FlDotCirclePainter(
                                radius: points.length > 20 ? 2.5 : 4,
                                color: _lineColor,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: _lineColor.withValues(alpha: 0.12),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                handleBuiltInTouches: false,
                touchSpotThreshold: 40,
                longPressDuration: const Duration(milliseconds: 300),
                touchCallback: _handleTouch,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
