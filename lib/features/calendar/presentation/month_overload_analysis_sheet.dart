import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/domain/models/month_overload_analysis.dart';
import 'package:progressive_lift/domain/services/ai_overload_coach_service.dart';
import 'package:progressive_lift/providers/app_providers.dart';
import 'package:progressive_lift/shared/widgets/muscle_group_chip.dart';

Future<void> showMonthOverloadAnalysisSheet(
  BuildContext context, {
  required DateTime month,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _MonthOverloadAnalysisSheet(month: month),
  );
}

class _MonthOverloadAnalysisSheet extends ConsumerWidget {
  const _MonthOverloadAnalysisSheet({required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsync = ref.watch(monthOverloadAnalysisProvider(month));
    final aiReportAsync = ref.watch(aiOverloadReportProvider(month));
    final monthLabel = '${month.year}年${month.month}月';

    return Scaffold(
      appBar: AppBar(
        title: Text('$monthLabel オーバーロード分析'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: analysisAsync.when(
        data: (analysis) {
          if (!analysis.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 48,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$monthLabel のトレーニング記録がありません',
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderScoreCard(analysis: analysis),
                const SizedBox(height: 16),
                aiReportAsync.when(
                  data: (report) => _AiCoachCard(report: report),
                  loading: () => const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  error: (e, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 20),
                _RankingSection(analysis: analysis),
                if (analysis.exerciseDetails.length >= 2) ...[
                  const SizedBox(height: 20),
                  _OneRmComparisonSection(analysis: analysis),
                ],
                const SizedBox(height: 20),
                _VolumeBalanceSection(analysis: analysis),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('エラー: $e')),
      ),
    );
  }
}

class _HeaderScoreCard extends StatelessWidget {
  const _HeaderScoreCard({required this.analysis});

  final MonthOverloadAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final rate = analysis.overloadRate;
    final prCount = analysis.totalPrEventsCount;
    final isGood = rate >= 50;

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isGood
                ? [
                    const Color(0xFF2E7D32).withValues(alpha: 0.35),
                    const Color(0xFF1B5E20).withValues(alpha: 0.1),
                  ]
                : [
                    const Color(0xFF1565C0).withValues(alpha: 0.35),
                    const Color(0xFF0D47A1).withValues(alpha: 0.1),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    color: isGood ? Colors.amber : Colors.blueAccent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '過負荷達成スコア',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${analysis.overloadedExercisesCount} / ${analysis.totalExercisesTracked} 種目で向上',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (isGood ? Colors.green : Colors.blue)
                        .withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isGood ? Colors.greenAccent : Colors.lightBlueAccent,
                    ),
                  ),
                  child: Text(
                    '${rate.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isGood
                          ? Colors.greenAccent
                          : Colors.lightBlueAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Colors.white12),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _HeaderMiniStat(
                  label: '月間PR更新',
                  value: '$prCount 回',
                  icon: Icons.trending_up,
                  color: Colors.amber,
                ),
                _HeaderMiniStat(
                  label: '停滞検知',
                  value: '${analysis.plateauExercises.length} 種目',
                  icon: Icons.warning_amber_rounded,
                  color: analysis.plateauExercises.isNotEmpty
                      ? Colors.orangeAccent
                      : Colors.white38,
                ),
                _HeaderMiniStat(
                  label: '実施種目数',
                  value: '${analysis.totalExercisesTracked} 種目',
                  icon: Icons.fitness_center,
                  color: Colors.lightBlueAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderMiniStat extends StatelessWidget {
  const _HeaderMiniStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.white54),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AiCoachCard extends StatelessWidget {
  const _AiCoachCard({required this.report});

  final AiOverloadReport report;

  @override
  Widget build(BuildContext context) {
    final gradeColor = switch (report.rankGrade) {
      'S' => Colors.amber,
      'A' => Colors.greenAccent,
      'B' => Colors.lightBlueAccent,
      _ => Colors.white70,
    };

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.amber.withValues(alpha: 0.35),
            width: 1.2,
          ),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF231E12),
              const Color(0xFF1A1D26),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'AI Overload Coach レポート',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: gradeColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: gradeColor),
                  ),
                  child: Text(
                    'Rank ${report.rankGrade}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: gradeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              report.gradeTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              report.scoreSummary,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            _CoachSectionBlock(
              title: '強度の伸び・総括',
              content: report.strengthSummary,
              icon: Icons.fitness_center,
            ),
            if (report.plateauWarning != null) ...[
              const SizedBox(height: 10),
              _CoachSectionBlock(
                title: '停滞（プラトー）分析',
                content: report.plateauWarning!,
                icon: Icons.warning_amber_rounded,
                isWarning: true,
              ),
            ],
            const SizedBox(height: 10),
            _CoachSectionBlock(
              title: '部位バランス',
              content: report.volumeBalanceSummary,
              icon: Icons.pie_chart_outline,
            ),
            if (report.nextMonthGoals.isNotEmpty) ...[
              const SizedBox(height: 14),
              const Text(
                '🎯 次月の推奨アクション',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,
                ),
              ),
              const SizedBox(height: 6),
              for (final goal in report.nextMonthGoals)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          goal,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CoachSectionBlock extends StatelessWidget {
  const _CoachSectionBlock({
    required this.title,
    required this.content,
    required this.icon,
    this.isWarning = false,
  });

  final String title;
  final String content;
  final IconData icon;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    final color = isWarning ? Colors.orangeAccent : Colors.white70;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: (isWarning ? Colors.orange : Colors.white)
            .withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _RankingSection extends StatelessWidget {
  const _RankingSection({required this.analysis});

  final MonthOverloadAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.military_tech, color: Colors.amber, size: 20),
            const SizedBox(width: 8),
            const Text(
              '月間 成長・伸び率ランキング',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < analysis.exerciseDetails.length; i++)
          _ExerciseRankCard(
            rank: i + 1,
            detail: analysis.exerciseDetails[i],
          ),
      ],
    );
  }
}

class _ExerciseRankCard extends StatelessWidget {
  const _ExerciseRankCard({
    required this.rank,
    required this.detail,
  });

  final int rank;
  final ExerciseOverloadDetail detail;

  @override
  Widget build(BuildContext context) {
    final baseTop = detail.baselineTop;
    final bestTop = detail.bestMonthTop;

    final gainPercent = detail.oneRmGainPercent;
    final isPositive = detail.oneRmDelta > 0.05;
    final isPlateau = detail.isPlateau;

    final rankColor = switch (rank) {
      1 => Colors.amber,
      2 => const Color(0xFFC0C0C0),
      3 => const Color(0xFFCD7F32),
      _ => Colors.white38,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: rankColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: rankColor, width: 1.2),
                  ),
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: rankColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    detail.exerciseName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                MuscleGroupChip(group: detail.muscleGroup, compact: true),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOPセット推移',
                          style: TextStyle(fontSize: 10, color: Colors.white54),
                        ),
                        const SizedBox(height: 2),
                        if (baseTop != null && bestTop != null)
                          Text(
                            '${_fmtW(baseTop.weightKg)}×${baseTop.reps}  ➔  ${_fmtW(bestTop.weightKg)}×${bestTop.reps}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        else
                          const Text('-', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '推定1RM',
                        style: TextStyle(fontSize: 10, color: Colors.white54),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${detail.bestOneRm.toStringAsFixed(1)}kg',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isPositive
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : isPlateau
                                      ? Colors.orange.withValues(alpha: 0.2)
                                      : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isPositive
                                  ? '+${gainPercent.toStringAsFixed(1)}%'
                                  : isPlateau
                                      ? '停滞'
                                      : '維持',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isPositive
                                    ? Colors.greenAccent
                                    : isPlateau
                                        ? Colors.orangeAccent
                                        : Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _fmtW(double w) =>
      w % 1 == 0 ? w.toStringAsFixed(0) : w.toStringAsFixed(1);
}

class _OneRmComparisonSection extends StatelessWidget {
  const _OneRmComparisonSection({required this.analysis});

  final MonthOverloadAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    // 実施回数が複数回の種目をピックアップ
    final multies =
        analysis.exerciseDetails.where((d) => d.sessionCountInMonth >= 2).take(4).toList();

    if (multies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.compare_arrows, color: Colors.lightBlueAccent, size: 20),
            SizedBox(width: 8),
            Text(
              '主要種目の 1RM 成長比較（月初 vs 月末）',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (final item in multies)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _OneRmBarRow(item: item),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OneRmBarRow extends StatelessWidget {
  const _OneRmBarRow({required this.item});

  final ExerciseOverloadDetail item;

  @override
  Widget build(BuildContext context) {
    final delta = item.oneRmDelta;
    final isUp = delta > 0.05;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.exerciseName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            Text(
              isUp
                  ? '+${delta.toStringAsFixed(1)}kg'
                  : '${delta.toStringAsFixed(1)}kg',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isUp ? Colors.greenAccent : Colors.white60,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            SizedBox(
              width: 54,
              child: Text(
                '${item.initialOneRm.toStringAsFixed(1)}kg',
                style: const TextStyle(fontSize: 11, color: Colors.white54),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: item.bestOneRm > 0
                        ? (item.initialOneRm / item.bestOneRm).clamp(0.1, 1.0)
                        : 0.5,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  if (isUp)
                    FractionallySizedBox(
                      widthFactor: 1.0,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 54,
              child: Text(
                '${item.bestOneRm.toStringAsFixed(1)}kg',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isUp ? Colors.greenAccent : Colors.white,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VolumeBalanceSection extends StatelessWidget {
  const _VolumeBalanceSection({required this.analysis});

  final MonthOverloadAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final volStr = analysis.totalVolumeKg >= 1000
        ? '${(analysis.totalVolumeKg / 1000).toStringAsFixed(1)} t'
        : '${analysis.totalVolumeKg.toStringAsFixed(0)} kg';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.layers, color: Colors.tealAccent, size: 20),
            SizedBox(width: 8),
            Text(
              '量とバランスの土台（参考）',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '月間総仕事量 (Tonnage)',
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                    Text(
                      volStr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                  ],
                ),
                if (analysis.volumeDeltaPercent != null) ...[
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '先月比: ${analysis.volumeDeltaPercent! >= 0 ? '+' : ''}${analysis.volumeDeltaPercent!.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 11,
                        color: analysis.volumeDeltaPercent! >= 0
                            ? Colors.greenAccent
                            : Colors.orangeAccent,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                const Divider(height: 1, color: Colors.white12),
                const SizedBox(height: 14),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '部位別 月間セット数',
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 8),
                for (final g in MuscleGroup.selectable)
                  if ((analysis.muscleGroupSetCounts[g] ?? 0) > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: MuscleGroupChip(group: g, compact: true),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final maxSets = analysis
                                    .muscleGroupSetCounts.values
                                    .fold<int>(0, (m, v) => v > m ? v : m);
                                final count =
                                    analysis.muscleGroupSetCounts[g] ?? 0;
                                final ratio =
                                    maxSets > 0 ? (count / maxSets) : 0.0;
                                return Stack(
                                  children: [
                                    Container(
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.05),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                    ),
                                    Container(
                                      height: 14,
                                      width: constraints.maxWidth * ratio,
                                      decoration: BoxDecoration(
                                        color: g.color.withValues(alpha: 0.7),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 44,
                            child: Text(
                              '${analysis.muscleGroupSetCounts[g] ?? 0} set',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
