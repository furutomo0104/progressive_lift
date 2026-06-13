import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/core/theme/cardio_style.dart';
import 'package:progressive_lift/domain/models/month_workout_analysis.dart';
import 'package:progressive_lift/providers/app_providers.dart';

class MonthSummaryPanel extends ConsumerWidget {
  const MonthSummaryPanel({super.key, required this.monthAnchor});

  final DateTime monthAnchor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsync = ref.watch(monthWorkoutAnalysisProvider(monthAnchor));

    return analysisAsync.when(
      data: (analysis) => _MonthSummaryBody(analysis: analysis),
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('サマリーの読み込みに失敗しました: $e'),
      ),
    );
  }
}

class _MonthSummaryBody extends StatelessWidget {
  const _MonthSummaryBody({required this.analysis});

  final MonthWorkoutAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat('M月', 'ja').format(analysis.month);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$monthLabelのサマリー',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            if (!analysis.hasData && !analysis.hasCardioData)
              Text(
                '今月はまだ記録がありません',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              )
            else ...[
              if (analysis.hasData) ...[
                _StatsRow(analysis: analysis),
                const SizedBox(height: 20),
                _MuscleBalanceSection(counts: analysis.muscleGroupSetCounts),
                const SizedBox(height: 20),
                _ProgressSection(
                  prCount: analysis.prExerciseCount,
                  highlights: analysis.highlights,
                ),
              ],
              if (analysis.hasCardioData) ...[
                if (analysis.hasData) const SizedBox(height: 20),
                _CardioSummarySection(analysis: analysis),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.analysis});

  final MonthWorkoutAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: 'トレーニング',
            value: '${analysis.trainingDays}日',
            delta: analysis.trainingDaysDelta,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            label: 'セット',
            value: '${analysis.totalSets}',
            delta: analysis.totalSetsDelta,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            label: 'PR更新',
            value: '${analysis.prExerciseCount}',
            subtitle: '種目',
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    this.delta,
    this.subtitle,
  });

  final String label;
  final String value;
  final int? delta;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          if (delta != null) ...[
            const SizedBox(height: 2),
            Text(
              _formatDelta(delta!),
              style: TextStyle(
                fontSize: 10,
                color: delta! >= 0
                    ? const Color(0xFF81C784)
                    : const Color(0xFFE57373),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDelta(int d) {
    if (d > 0) return '先月比 +$d';
    if (d < 0) return '先月比 $d';
    return '先月と同じ';
  }
}

class _MuscleBalanceSection extends StatelessWidget {
  const _MuscleBalanceSection({required this.counts});

  final Map<MuscleGroup, int> counts;

  @override
  Widget build(BuildContext context) {
    if (counts.isEmpty) return const SizedBox.shrink();

    final sorted = MuscleGroup.selectable
        .where((g) => (counts[g] ?? 0) > 0)
        .map((g) => MapEntry(g, counts[g]!))
        .toList();
    final total = sorted.fold<int>(0, (sum, e) => sum + e.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '部位バランス',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 10,
            child: Row(
              children: [
                for (final entry in sorted)
                  Expanded(
                    flex: entry.value,
                    child: Container(color: entry.key.color),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 6,
          children: [
            for (final entry in sorted)
              Text(
                '${entry.key.label}${entry.value}',
                style: TextStyle(
                  fontSize: 12,
                  color: entry.key.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        if (total > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '部位別セット数（合計$total）',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.prCount,
    required this.highlights,
  });

  final int prCount;
  final List<MonthProgressHighlight> highlights;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '今月の伸び',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 10),
        if (highlights.isEmpty)
          Text(
            prCount == 0
                ? '記録を続けると、更新した種目がここに表示されます'
                : '今月はPR更新がありません',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.45),
            ),
          )
        else
          ...highlights.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.north_east,
                    size: 16,
                    color: Color(0xFF81C784),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: h.exerciseName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: '\n'),
                          TextSpan(
                            text:
                                '${_fmtWeight(h.previousWeightKg)}kg×${h.previousReps}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                            ),
                          ),
                          const TextSpan(text: ' → '),
                          TextSpan(
                            text: '${_fmtWeight(h.newWeightKg)}kg×${h.newReps}',
                            style: const TextStyle(
                              color: Color(0xFF81C784),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _fmtWeight(double w) {
    return w % 1 == 0 ? w.toStringAsFixed(0) : w.toStringAsFixed(1);
  }
}

class _CardioSummarySection extends StatelessWidget {
  const _CardioSummarySection({required this.analysis});

  final MonthWorkoutAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CardioStyle.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CardioStyle.accent.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(
            CardioStyle.icon,
            size: 20,
            color: CardioStyle.accent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '有酸素  ${analysis.cardioCount}回 · 合計 ${analysis.cardioTotalMinutes}分',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
