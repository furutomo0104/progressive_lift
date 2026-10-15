import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:progressive_lift/domain/services/volume_calculator.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/widgets/chart_point_readout.dart';

const _lineColor = Color(0xFF4DB6AC);

class VolumeTrendChart extends StatefulWidget {
  const VolumeTrendChart({
    super.key,
    required this.points,
    this.height = 260,
  });

  final List<VolumePoint> points;
  final double height;

  @override
  State<VolumeTrendChart> createState() => _VolumeTrendChartState();
}

class _VolumeTrendChartState extends State<VolumeTrendChart> {
  int? _selectedIndex;

  List<VolumePoint> get points => widget.points;

  @override
  void didUpdateWidget(covariant VolumeTrendChart oldWidget) {
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

  static String _formatVolume(double kg) {
    if (kg >= 1000) {
      return '${(kg / 1000).toStringAsFixed(1)}t';
    }
    return '${kg.toStringAsFixed(0)}kg';
  }

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('ボリュームの記録がありません')),
      );
    }

    final values = points.map((p) => p.totalVolumeKg).toList();
    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final diff = maxV - minV;
    final pad = diff > 0
        ? (diff * 0.15).clamp(10.0, 1000.0)
        : (maxV > 0 ? maxV * 0.15 : 20.0).clamp(10.0, 1000.0);
    final minY = (minV - pad).clamp(0.0, double.infinity).floorToDouble();
    var maxY = (maxV + pad).ceilToDouble();
    if (maxY <= minY) {
      maxY = minY + 20.0;
    }
    final dateFmt = DateFormat('M/d');
    final selected = _selectedIndex;
    final shown = points[selected ?? points.length - 1];

    final spots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].totalVolumeKg),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ChartPointReadout(
          date: shown.date,
          weightKg: shown.topWeightKg,
          reps: shown.topReps,
          isDefault: selected == null,
          metric: 'Vol ${_formatVolume(shown.totalVolumeKg)}',
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
                    reservedSize: 46,
                    getTitlesWidget: (value, meta) {
                      if (value >= 1000) {
                        final k = value / 1000;
                        if ((k * 10 - (k * 10).round()).abs() > 0.01) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          '${k.toStringAsFixed(k % 1 == 0 ? 0 : 1)}t',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                        );
                      }
                      if ((value - value.roundToDouble()).abs() > 0.01) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        '${value.toStringAsFixed(0)}kg',
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
