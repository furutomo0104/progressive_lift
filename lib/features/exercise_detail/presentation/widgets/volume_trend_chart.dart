import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progressive_lift/domain/services/volume_calculator.dart';

class VolumeTrendChart extends StatelessWidget {
  const VolumeTrendChart({
    super.key,
    required this.points,
    this.height = 260,
  });

  final List<VolumePoint> points;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return SizedBox(
        height: height,
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

    final spots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].totalVolumeKg),
    ];

    return SizedBox(
      height: height,
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
                getTitlesWidget: (value, meta) {
                  final i = value.round();
                  if (i < 0 || i >= points.length) {
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
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              color: const Color(0xFF4DB6AC),
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF4DB6AC).withValues(alpha: 0.12),
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
                  '総ボリューム: ${_formatVolume(p.totalVolumeKg)}\n'
                  '${p.totalSets}セット · ${p.totalReps}reps',
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  static String _formatVolume(double kg) {
    if (kg >= 1000) {
      return '${(kg / 1000).toStringAsFixed(1)}t';
    }
    return '${kg.toStringAsFixed(0)}kg';
  }
}
