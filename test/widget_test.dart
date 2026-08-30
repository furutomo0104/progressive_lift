import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:progressive_lift/app.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/domain/models/month_overload_analysis.dart';
import 'package:progressive_lift/domain/models/top_set_point.dart';
import 'package:progressive_lift/domain/services/ai_overload_coach_service.dart';
import 'package:progressive_lift/domain/services/gemini_overload_coach_service.dart';
import 'package:progressive_lift/domain/services/volume_calculator.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/widgets/top_set_combo_chart.dart';
import 'package:progressive_lift/features/exercise_detail/presentation/widgets/volume_trend_chart.dart';

void main() {
  testWidgets('アプリが起動する', (WidgetTester tester) async {
    await tester.pumpWidget(const ProgressiveLiftApp());
    await tester.pump();
    expect(find.text('筋記録'), findsOneWidget);
  });

  testWidgets('VolumeTrendChartが小さいボリュームや1件でも正しく描画される', (tester) async {
    final points = [
      VolumePoint(
        date: DateTime(2026, 8, 1),
        totalVolumeKg: 50.0,
        totalSets: 1,
        totalReps: 5,
      ),
      VolumePoint(
        date: DateTime(2026, 8, 8),
        totalVolumeKg: 50.0,
        totalSets: 1,
        totalReps: 5,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VolumeTrendChart(points: points),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(VolumeTrendChart), findsOneWidget);
  });

  testWidgets('TopSetComboChartが重量と回数のラベル・軸つきで正しく描画される', (tester) async {
    final points = [
      TopSetPoint(
        date: DateTime(2026, 8, 1),
        weightKg: 80.0,
        reps: 8,
      ),
      TopSetPoint(
        date: DateTime(2026, 8, 8),
        weightKg: 82.5,
        reps: 8,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TopSetComboChart(points: points),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('重量 (kg)'), findsOneWidget);
    expect(find.text('回数 (reps)'), findsOneWidget);
    expect(find.text('折れ線：最高重量 (kg)'), findsOneWidget);
    expect(find.text('棒：回数 (reps)'), findsOneWidget);
  });

  test('AiOverloadCoachServiceがルールベースで正常にレポートを生成する', () {
    final analysis = MonthOverloadAnalysis(
      month: DateTime(2026, 8, 1),
      totalExercisesTracked: 3,
      overloadedExercisesCount: 2,
      totalPrEventsCount: 3,
      exerciseDetails: [
        ExerciseOverloadDetail(
          exerciseKey: 'bench_press',
          exerciseName: 'ベンチプレス',
          muscleGroup: MuscleGroup.chest,
          baselineTop: TopSetPoint(
            date: DateTime(2026, 7, 20),
            weightKg: 100,
            reps: 5,
          ),
          bestMonthTop: TopSetPoint(
            date: DateTime(2026, 8, 10),
            weightKg: 105,
            reps: 5,
          ),
          latestMonthTop: TopSetPoint(
            date: DateTime(2026, 8, 20),
            weightKg: 105,
            reps: 5,
          ),
          initialOneRm: 116.7,
          bestOneRm: 122.5,
          sessionCountInMonth: 3,
          isOverloaded: true,
          isPlateau: false,
        ),
      ],
      plateauExercises: const [],
      muscleGroupSetCounts: const {
        MuscleGroup.chest: 15,
        MuscleGroup.legs: 10,
      },
      totalVolumeKg: 12000,
    );

    final report = AiOverloadCoachService.generateReport(analysis);
    expect(report.rankGrade, 'S');
    expect(report.isGeminiGenerated, isFalse);
    expect(report.scoreSummary, contains('過負荷を達成'));
  });

  test('GeminiOverloadCoachServiceがAPIキー未設定時はnullを返す', () async {
    final analysis = MonthOverloadAnalysis(
      month: DateTime(2026, 8, 1),
      totalExercisesTracked: 0,
      overloadedExercisesCount: 0,
      totalPrEventsCount: 0,
      exerciseDetails: const [],
      plateauExercises: const [],
      muscleGroupSetCounts: const {},
      totalVolumeKg: 0,
    );

    final report = await GeminiOverloadCoachService.generateGeminiReport(analysis);
    expect(report, isNull);
  });
}
