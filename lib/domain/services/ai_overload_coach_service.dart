import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/domain/models/month_overload_analysis.dart';

class AiOverloadReport {
  const AiOverloadReport({
    required this.rankGrade,
    required this.gradeTitle,
    required this.scoreSummary,
    required this.strengthSummary,
    required this.plateauWarning,
    required this.volumeBalanceSummary,
    required this.nextMonthGoals,
    this.isGeminiGenerated = false,
  });

  final String rankGrade;
  final String gradeTitle;
  final String scoreSummary;
  final String strengthSummary;
  final String? plateauWarning;
  final String volumeBalanceSummary;
  final List<String> nextMonthGoals;
  final bool isGeminiGenerated;
}

class AiOverloadCoachService {
  static AiOverloadReport generateReport(MonthOverloadAnalysis analysis) {
    if (!analysis.hasData) {
      return const AiOverloadReport(
        rankGrade: '-',
        gradeTitle: 'データ収集中',
        scoreSummary: '今月のトレーニングデータがまだありません。',
        strengthSummary: '記録を追加すると、AIが筋力の成長と過負荷の達成度を分析します。',
        plateauWarning: null,
        volumeBalanceSummary: 'まずは各部位のセットを記録していきましょう。',
        nextMonthGoals: ['まずは1セッション記録する'],
      );
    }

    final rate = analysis.overloadRate;
    final prCount = analysis.totalPrEventsCount;
    final totalEx = analysis.totalExercisesTracked;
    final topGainer = analysis.exerciseDetails.isNotEmpty
        ? analysis.exerciseDetails.first
        : null;

    // 1. ランク判定
    String rank;
    String title;
    if (rate >= 65 && prCount >= 3) {
      rank = 'S';
      title = '圧倒的な過負荷達成！';
    } else if (rate >= 45 || prCount >= 2) {
      rank = 'A';
      title = '着実に筋力向上中';
    } else if (rate >= 20 || prCount >= 1) {
      rank = 'B';
      title = '維持〜部分的な成長';
    } else {
      rank = 'C';
      title = '次月へ向けた土台作り';
    }

    // 2. スコアサマリー
    final scoreSummary =
        '実施した $totalEx 種目中 ${analysis.overloadedExercisesCount} 種目（${rate.toStringAsFixed(0)}%）で過負荷を達成。月間で合計 $prCount 回のPR更新が記録されました。';

    // 3. 筋力・強度の伸び総括
    final StringBuffer strengthBuf = StringBuffer();
    if (topGainer != null && topGainer.isOverloaded) {
      final gainStr = topGainer.oneRmDelta > 0
          ? '+${topGainer.oneRmDelta.toStringAsFixed(1)}kg'
          : '+${topGainer.repDelta} reps';
      strengthBuf.write(
        '特に「${topGainer.exerciseName}」は推定1RMが ${topGainer.initialOneRm.toStringAsFixed(1)}kg から ${topGainer.bestOneRm.toStringAsFixed(1)}kg（$gainStr, +${topGainer.oneRmGainPercent.toStringAsFixed(1)}%）へ大きく伸長し、今月の成長を強く牽引しています。',
      );
    } else {
      strengthBuf.write(
        'ベースの重量・回数は概ね維持されています。次回はメイン種目で+1レップまたは+1.25〜2.5kgの微増に挑戦してみましょう。',
      );
    }

    if (analysis.totalVolumeKg > 0) {
      final volStr = analysis.totalVolumeKg >= 1000
          ? '${(analysis.totalVolumeKg / 1000).toStringAsFixed(1)}t'
          : '${analysis.totalVolumeKg.toStringAsFixed(0)}kg';
      if (analysis.volumeDeltaPercent != null) {
        final sign = analysis.volumeDeltaPercent! >= 0 ? '+' : '';
        strengthBuf.write(
          ' 月間総仕事量は $volStr（先月比 $sign${analysis.volumeDeltaPercent!.toStringAsFixed(1)}%）です。',
        );
      }
    }

    // 4. 停滞種目の検知
    String? plateauWarning;
    if (analysis.plateauExercises.isNotEmpty) {
      final plateauEx = analysis.plateauExercises.first;
      plateauWarning =
          '「${plateauEx.exerciseName}」は当月 ${plateauEx.sessionCountInMonth} 回の実施でトップセットの更新が見られず、停滞（プラトー）の兆候があります。重量を変えずにレスト時間を延ばすか、補助種目を取り入れて刺激に変化をつけるのが有効です。';
    } else if (analysis.overloadedExercisesCount == totalEx && totalEx > 0) {
      plateauWarning =
          '目立った停滞種目はなく、記録した全種目で順調に強度が更新または維持されています。';
    }

    // 5. 部位バランス判定
    final counts = analysis.muscleGroupSetCounts;
    final totalSets = counts.values.fold<int>(0, (s, c) => s + c);
    final StringBuffer balanceBuf = StringBuffer();

    if (totalSets > 0) {
      final sortedGroups = counts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final topGroup = sortedGroups.first;
      final legSets = counts[MuscleGroup.legs] ?? 0;

      balanceBuf.write(
        '部位別では「${topGroup.key.label}」が最多（${topGroup.value}セット）で主軸となっています。',
      );

      if (legSets == 0 && totalEx >= 3) {
        balanceBuf.write(' 下半身（脚）の記録がありません。脚の種目を加えることで全身の筋力基盤がさらに強固になります。');
      } else if (legSets > 0 && legSets < (totalSets * 0.12).round()) {
        balanceBuf.write(' 上半身に対して脚の比率（$legSetsセット）がやや控えめです。週に2〜3セット追加を推奨します。');
      } else {
        balanceBuf.write(' 各部位に適度な刺激が行き届いており、良好なバランスです。');
      }
    } else {
      balanceBuf.write('部位の偏りは見られません。');
    }

    // 6. 次月の推奨アクション
    final List<String> goals = [];
    if (topGainer != null && topGainer.bestMonthTop != null) {
      final nextWeight = topGainer.bestMonthTop!.weightKg + 2.5;
      final nextReps = (topGainer.bestMonthTop!.reps - 1).clamp(3, 12);
      final weightLabel = nextWeight % 1 == 0
          ? nextWeight.toStringAsFixed(0)
          : nextWeight.toStringAsFixed(1);
      goals.add(
        '${topGainer.exerciseName}: 次月第1週に ${weightLabel}kg × $nextReps reps の突破を狙う',
      );
    }

    if (analysis.plateauExercises.isNotEmpty) {
      final p = analysis.plateauExercises.first;
      goals.add('${p.exerciseName}: レップ数維持のままインターバルを1分延長して再挑戦');
    }

    if (goals.length < 3) {
      goals.add('全種目の過負荷達成率 70% 以上をキープする');
    }

    return AiOverloadReport(
      rankGrade: rank,
      gradeTitle: title,
      scoreSummary: scoreSummary,
      strengthSummary: strengthBuf.toString(),
      plateauWarning: plateauWarning,
      volumeBalanceSummary: balanceBuf.toString(),
      nextMonthGoals: goals,
    );
  }
}
