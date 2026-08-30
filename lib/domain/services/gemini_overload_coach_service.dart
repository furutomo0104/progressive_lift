import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/domain/models/month_overload_analysis.dart';
import 'package:progressive_lift/domain/services/ai_overload_coach_service.dart';

/// Gemini 1.5 Flash を活用した高精度 Overload Coach サービス
class GeminiOverloadCoachService {
  static const _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  static bool get hasApiKey => _apiKey.trim().isNotEmpty;

  static const _candidateModels = [
    'gemini-1.5-flash',
    'gemini-1.5-flash-latest',
    'gemini-1.5-flash-8b',
    'gemini-2.0-flash',
    'gemini-2.0-flash-exp',
    'gemini-1.5-pro',
  ];

  /// Gemini API を用いて月間レポートを生成（失敗時やAPIキー未設定時は null を返す）
  static Future<AiOverloadReport?> generateGeminiReport(
    MonthOverloadAnalysis analysis,
  ) async {
    if (!hasApiKey || !analysis.hasData) return null;

    final prompt = _buildAnalysisPrompt(analysis);

    for (final modelName in _candidateModels) {
      try {
        final model = GenerativeModel(
          model: modelName,
          apiKey: _apiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            temperature: 0.7,
          ),
          systemInstruction: Content.system(
            'あなたは「筋記録」専任のプロ・ストレングス＆コンディショニングコーチです。\n'
            '科学的トレーニング原則（特に漸進性過負荷 / Progressive Overload、有効セット数、プラトー打破、疲労管理）に基づき、'
            'ユーザーの月間ワークアウトデータを分析し、日本語で具体的かつ論理的・熱意あるフィードバックを提供してください。\n\n'
            '【出力制約】\n'
            '指定されたJSONスキーマに従い、有効なJSONオブジェクトのみを返してください。マークダウンの囲み（```json）は不要です。',
          ),
        );

        final response = await model.generateContent([Content.text(prompt)]);
        final rawText = response.text?.trim();

        if (rawText == null || rawText.isEmpty) continue;

        final jsonMap =
            jsonDecode(_cleanJsonText(rawText)) as Map<String, dynamic>;

        final rankGrade = (jsonMap['rankGrade'] as String?)?.trim() ?? 'A';
        final gradeTitle =
            (jsonMap['gradeTitle'] as String?)?.trim() ?? '過負荷の達成';
        final scoreSummary = (jsonMap['scoreSummary'] as String?)?.trim() ?? '';
        final strengthSummary =
            (jsonMap['strengthSummary'] as String?)?.trim() ?? '';
        final plateauWarning = (jsonMap['plateauWarning'] as String?)?.trim();
        final volumeBalanceSummary =
            (jsonMap['volumeBalanceSummary'] as String?)?.trim() ?? '';
        final rawGoals = jsonMap['nextMonthGoals'] as List<dynamic>? ?? [];
        final nextMonthGoals = rawGoals
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();

        return AiOverloadReport(
          rankGrade: rankGrade,
          gradeTitle: gradeTitle,
          scoreSummary: scoreSummary,
          strengthSummary: strengthSummary,
          plateauWarning:
              plateauWarning?.isEmpty == true ? null : plateauWarning,
          volumeBalanceSummary: volumeBalanceSummary,
          nextMonthGoals: nextMonthGoals.isNotEmpty
              ? nextMonthGoals
              : ['全種目の過負荷達成率 70% 以上をキープする'],
          isGeminiGenerated: true,
        );
      } catch (e) {
        debugPrint('GeminiOverloadCoachService ($modelName) failed: $e');
        // 次のモデル候補を試行
        continue;
      }
    }

    return null;
  }

  static String _buildAnalysisPrompt(MonthOverloadAnalysis analysis) {
    final monthLabel = '${analysis.month.year}年${analysis.month.month}月';
    final volStr = analysis.totalVolumeKg >= 1000
        ? '${(analysis.totalVolumeKg / 1000).toStringAsFixed(1)}t'
        : '${analysis.totalVolumeKg.toStringAsFixed(0)}kg';

    final exerciseLines = <String>[];
    for (final ex in analysis.exerciseDetails) {
      final base = ex.baselineTop != null
          ? '${ex.baselineTop!.weightKg}kg×${ex.baselineTop!.reps}回 (1RM: ${ex.initialOneRm.toStringAsFixed(1)}kg)'
          : '初記録';
      final best = ex.bestMonthTop != null
          ? '${ex.bestMonthTop!.weightKg}kg×${ex.bestMonthTop!.reps}回 (1RM: ${ex.bestOneRm.toStringAsFixed(1)}kg)'
          : '-';
      final gain = ex.oneRmDelta > 0
          ? '+${ex.oneRmDelta.toStringAsFixed(1)}kg (+${ex.oneRmGainPercent.toStringAsFixed(1)}%)'
          : '±0kg';
      final status = ex.isPlateau
          ? '【停滞・プラトー懸念（${ex.sessionCountInMonth}回実施）】'
          : ex.isOverloaded
              ? '【過負荷・PR達成】'
              : '【維持】';
      exerciseLines.add(
        '- ${ex.exerciseName} (${ex.muscleGroup.label}): 前回TOP $base ➔ 今月最高 $best [1RM変化: $gain] $status',
      );
    }

    final muscleLines = <String>[];
    for (final g in MuscleGroup.selectable) {
      final count = analysis.muscleGroupSetCounts[g] ?? 0;
      if (count > 0) {
        muscleLines.add('- ${g.label}: $count セット');
      }
    }

    return '''
以下の $monthLabel のトレーニングデータを分析し、JSON形式で返してください。

【基本実績】
・実施種目数: ${analysis.totalExercisesTracked} 種目
・過負荷（PR）達成種目数: ${analysis.overloadedExercisesCount} 種目 (達成率: ${analysis.overloadRate.toStringAsFixed(0)}%)
・月間PR更新総回数: ${analysis.totalPrEventsCount} 回
・月間総仕事量: $volStr ${analysis.volumeDeltaPercent != null ? '(先月比: ${analysis.volumeDeltaPercent! >= 0 ? '+' : ''}${analysis.volumeDeltaPercent!.toStringAsFixed(1)}%)' : ''}

【種目別トップセット＆推定1RM推移】
${exerciseLines.join('\n')}

【部位別月間セット数】
${muscleLines.isNotEmpty ? muscleLines.join('\n') : 'データなし'}

---
【出力JSONスキーマ】
{
  "rankGrade": "S" または "A" または "B" または "C",
  "gradeTitle": "今月を象徴する魅力的なタイトル（例: プレス系で圧倒的な過負荷を達成！）",
  "scoreSummary": "全体の過負荷達成度とPR回数についての総括（1〜2文）",
  "strengthSummary": "最も成長した種目を具体的に名指しして称賛し、筋力向上の意義を解説（2〜3文）",
  "plateauWarning": "停滞種目がある場合、原因考察と具体的な打破アドバイス（レスト延長や補助種目など）。停滞種目がない場合はnull",
  "volumeBalanceSummary": "部位バランス（主軸部位や不足部位など）に関するフィードバック（2文）",
  "nextMonthGoals": [
    "来月1〜2週目に狙うべき具体的種目の目標（重量・回数）",
    "停滞打破やボリューム調整のアクション目標",
    "月間全体の過負荷目標"
  ]
}
''';
  }

  static String _cleanJsonText(String text) {
    var cleaned = text;
    if (cleaned.startsWith('```json')) {
      cleaned = cleaned.substring(7);
    } else if (cleaned.startsWith('```')) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.endsWith('```')) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }
    return cleaned.trim();
  }
}
