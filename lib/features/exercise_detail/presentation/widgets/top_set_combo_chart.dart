import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:progressive_lift/domain/models/top_set_point.dart';

const _leftAxisReserved = 46.0;
const _rightAxisReserved = 42.0;
const _bottomAxisReserved = 28.0;
const _minSlotWidth = 28.0;

const _weightColor = Color(0xFF7986CB);
const _repsColor = Color(0xFF4FC3F7);

/// トップセット特化型複合グラフ
/// - 左Y軸: 最高重量（折れ線 / 紫）
/// - 右Y軸: 回数（棒 / 水色）
/// - 記録が増えても棒が重ならないよう、スロット幅に応じて棒幅を縮小し、必要なら横スクロール
/// - タップ／長押しした日の重量・回数はグラフ上部の固定表示に出す（指で隠れない・範囲外に出ない）
class TopSetComboChart extends StatefulWidget {
  const TopSetComboChart({
    super.key,
    required this.points,
    this.height = 260,
  });

  final List<TopSetPoint> points;
  final double height;

  @override
  State<TopSetComboChart> createState() => _TopSetComboChartState();
}

class _TopSetComboChartState extends State<TopSetComboChart> {
  int? _selectedIndex;

  List<TopSetPoint> get points => widget.points;
  double get height => widget.height;

  @override
  void didUpdateWidget(covariant TopSetComboChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    final selected = _selectedIndex;
    if (selected != null && selected >= points.length) {
      _selectedIndex = null;
    }
  }

  void _handleTouch(FlTouchEvent event, LineTouchResponse? response) {
    if (event is! FlTapUpEvent &&
        event is! FlLongPressStart &&
        event is! FlLongPressMoveUpdate) {
      return;
    }
    final spots = response?.lineBarSpots;
    if (spots == null || spots.isEmpty) return;
    final i = spots.first.x.round();
    if (i < 0 || i >= points.length || i == _selectedIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedIndex = i);
  }

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

    final weightDiff = maxW - minW;
    final weightPad = weightDiff > 0
        ? (weightDiff * 0.15).clamp(2.5, 10.0)
        : (maxW > 0 ? maxW * 0.15 : 5.0).clamp(2.5, 10.0);
    const repsPad = 1.0;

    final minWeightAxis =
        (minW - weightPad).clamp(0.0, double.infinity).floorToDouble();
    var maxWeightAxis = (maxW + weightPad).ceilToDouble();
    if (maxWeightAxis <= minWeightAxis) {
      maxWeightAxis = minWeightAxis + 10.0;
    }

    final minRepsAxis = (minR - repsPad).clamp(0.0, 20.0).floorToDouble();
    var maxRepsAxis = (maxR + repsPad + 1).ceilToDouble();
    if (maxRepsAxis <= minRepsAxis) {
      maxRepsAxis = minRepsAxis + 5.0;
    }

    double mapReps(double r) {
      final rangeW = maxWeightAxis - minWeightAxis;
      final rangeR = maxRepsAxis - minRepsAxis;
      if (rangeR == 0) return minWeightAxis;
      return minWeightAxis + (r - minRepsAxis) / rangeR * rangeW;
    }

    // 日付ラベルの間引き（多いときは隔日・3日おき）
    final labelStep = points.length <= 8
        ? 1
        : points.length <= 16
            ? 2
            : points.length <= 30
                ? 3
                : 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 3,
                    decoration: BoxDecoration(
                      color: _weightColor,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '重量 (kg)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _weightColor,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '回数 (reps)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _repsColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 8,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _repsColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        _SelectedPointReadout(
          point: points[_selectedIndex ?? points.length - 1],
          isDefault: _selectedIndex == null,
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            final availablePlotWidth = math.max(
              0.0,
              constraints.maxWidth - _leftAxisReserved - _rightAxisReserved,
            );
            final neededWidth = points.length * _minSlotWidth;
            final scrollable = neededWidth > availablePlotWidth + 1;
            final plotWidth =
                scrollable ? neededWidth : availablePlotWidth;
            final slotWidth = plotWidth / points.length;
            // 棒幅はスロットの約55%、最大14・最小3
            final barWidth = (slotWidth * 0.55).clamp(3.0, 14.0);

            final selected = _selectedIndex;
            final lineSpots = <FlSpot>[];
            final repBarSeries = <LineChartBarData>[];

            for (var i = 0; i < points.length; i++) {
              final p = points[i];
              final x = i.toDouble();
              lineSpots.add(FlSpot(x, p.weightKg));
              final barAlpha = selected == null
                  ? 0.75
                  : (i == selected ? 1.0 : 0.4);
              repBarSeries.add(
                LineChartBarData(
                  spots: [
                    FlSpot(x, minWeightAxis),
                    FlSpot(x, mapReps(p.reps.toDouble())),
                  ],
                  isCurved: false,
                  color: _repsColor.withValues(alpha: barAlpha),
                  barWidth: barWidth,
                  isStrokeCapRound: false,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              );
            }

            final minX = -0.5;
            final maxX = points.length - 0.5;

            final chart = SizedBox(
              width: plotWidth + _leftAxisReserved + _rightAxisReserved,
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
                    labelStep: labelStep,
                  ),
                  lineBarsData: [
                    ...repBarSeries,
                    LineChartBarData(
                      spots: lineSpots,
                      isCurved: false,
                      color: _weightColor,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) =>
                            index == selected
                                ? FlDotCirclePainter(
                                    radius: 6,
                                    color: Colors.white,
                                    strokeWidth: 3,
                                    strokeColor: _weightColor,
                                  )
                                : FlDotCirclePainter(
                                    radius: points.length > 20 ? 2.5 : 4,
                                    color: _weightColor,
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: _weightColor.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
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
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: false,
                    touchSpotThreshold: slotWidth,
                    longPressDuration: const Duration(milliseconds: 300),
                    touchCallback: _handleTouch,
                  ),
                ),
              ),
            );

            if (!scrollable) return chart;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ScrollToLatestView(
                  contentKey: points.length,
                  child: chart,
                ),
                const SizedBox(height: 4),
                const Text(
                  '← 左にスワイプで過去の記録を表示',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.white38),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendItem(
              color: _weightColor,
              label: '折れ線：最高重量 (kg)',
              isLine: true,
            ),
            SizedBox(width: 18),
            _LegendItem(
              color: _repsColor,
              label: '棒：回数 (reps)',
              isLine: false,
            ),
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
    required int labelStep,
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
              '${repValue.round()}回',
              style: const TextStyle(fontSize: 10, color: _repsColor),
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
              '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}kg',
              style: const TextStyle(fontSize: 10, color: Colors.white70),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: _bottomAxisReserved,
          interval: 1,
          getTitlesWidget: (value, meta) {
            final i = value.round();
            if (i < 0 || i >= points.length) return const SizedBox.shrink();
            // 端点は必ず表示、途中は間引き
            final isEdge = i == 0 || i == points.length - 1;
            if (!isEdge && i % labelStep != 0) {
              return const SizedBox.shrink();
            }
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

/// 選択中（未選択時は最新）のトップセットを常に同じ位置に表示する。
class _SelectedPointReadout extends StatelessWidget {
  const _SelectedPointReadout({
    required this.point,
    required this.isDefault,
  });

  final TopSetPoint point;
  final bool isDefault;

  static const _weekdays = ['月', '火', '水', '木', '金', '土', '日'];

  static String _formatWeight(double w) =>
      w % 1 == 0 ? w.toStringAsFixed(0) : w.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    const valueStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    final d = point.date;
    final dateLabel = '${d.month}/${d.day}(${_weekdays[d.weekday - 1]})';
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
          Text(
            '${_formatWeight(point.weightKg)}kg',
            style: valueStyle.copyWith(color: _weightColor),
          ),
          const Text(
            ' × ',
            style: TextStyle(fontSize: 14, color: Colors.white38),
          ),
          Text(
            '${point.reps}回',
            style: valueStyle.copyWith(color: _repsColor),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.isLine,
  });

  final Color color;
  final String label;
  final bool isLine;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLine)
          Container(
            width: 14,
            height: 3,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1.5),
            ),
          )
        else
          Container(
            width: 8,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }
}

/// 横スクロール時に最新（右端）を初期表示する。
class _ScrollToLatestView extends StatefulWidget {
  const _ScrollToLatestView({
    required this.child,
    required this.contentKey,
  });

  final Widget child;
  final Object contentKey;

  @override
  State<_ScrollToLatestView> createState() => _ScrollToLatestViewState();
}

class _ScrollToLatestViewState extends State<_ScrollToLatestView> {
  final _controller = ScrollController();
  var _didJump = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToLatest());
  }

  @override
  void didUpdateWidget(covariant _ScrollToLatestView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contentKey != widget.contentKey) {
      _didJump = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToLatest());
    }
  }

  void _jumpToLatest() {
    if (!mounted || _didJump) return;
    if (!_controller.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToLatest());
      return;
    }
    final max = _controller.position.maxScrollExtent;
    if (max > 0) {
      _controller.jumpTo(max);
    }
    _didJump = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      child: widget.child,
    );
  }
}
