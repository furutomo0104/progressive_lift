import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:progressive_lift/data/repositories/workout_repository.dart';
import 'package:progressive_lift/features/calendar/presentation/day_workout_sheet.dart';
import 'package:progressive_lift/features/calendar/presentation/widgets/month_summary_panel.dart';
import 'package:progressive_lift/features/paywall/presentation/paywall_sheet.dart';
import 'package:progressive_lift/providers/app_providers.dart';
import 'package:progressive_lift/shared/widgets/calendar_day_cell.dart';
import 'package:progressive_lift/shared/widgets/muscle_group_legend.dart';

class CalendarScreen extends HookConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusedDay = useState(DateTime.now());
    final selectedDay = useState<DateTime?>(DateTime.now());

    final isPro =
        ref.watch(proSubscriptionNotifierProvider).valueOrNull ?? false;

    // 無料版は直近3ヶ月以前の過去カレンダー閲覧時に解放バナーを表示
    final now = DateTime.now();
    final monthsAgo = (now.year - focusedDay.value.year) * 12 +
        (now.month - focusedDay.value.month);
    final isLockedPastMonth = !isPro && monthsAgo > 2;

    final summariesAsync = ref.watch(
      calendarSummariesProvider(focusedDay.value),
    );

    final summaries = isLockedPastMonth
        ? <DateTime, DayWorkoutSummary>{}
        : summariesAsync.maybeWhen(
            data: (m) => m,
            orElse: () => <DateTime, DayWorkoutSummary>{},
          );

    Future<void> pickMonth() async {
      final now = focusedDay.value;
      var tempYear = now.year;
      var tempMonth = now.month;

      final picked = await showDialog<DateTime>(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                title: const Text('年月を選択'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: tempYear > 2020
                              ? () => setModalState(() => tempYear--)
                              : null,
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '$tempYear年',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: tempYear < 2030
                              ? () => setModalState(() => tempYear++)
                              : null,
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(12, (index) {
                        final m = index + 1;
                        final isSelected = m == tempMonth;
                        return ChoiceChip(
                          label: Text('$m月'),
                          selected: isSelected,
                          onSelected: (_) {
                            setModalState(() => tempMonth = m);
                          },
                        );
                      }),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('キャンセル'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(
                      ctx,
                      DateTime.utc(tempYear, tempMonth, 1),
                    ),
                    child: const Text('決定'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (picked != null) {
        focusedDay.value = picked;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('筋記録'),
        actions: [
          if (isPro)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber, width: 1.2),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.workspace_premium, size: 14, color: Colors.amber),
                  SizedBox(width: 4),
                  Text(
                    'PRO',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            )
          else
            TextButton.icon(
              onPressed: () => showPaywallSheet(context),
              icon: const Icon(Icons.workspace_premium,
                  size: 16, color: Colors.amber),
              label: const Text(
                'PRO加入',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: MuscleGroupLegend(),
          ),
          const SizedBox(height: 8),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDay.value,
            rowHeight: 58,
            selectedDayPredicate: (day) => isSameDay(selectedDay.value, day),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (selected, focused) {
              selectedDay.value = selected;
              focusedDay.value = focused;
              showDayWorkoutSheet(context, selected);
            },
            onPageChanged: (focused) => focusedDay.value = focused,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendTextStyle: const TextStyle(color: Colors.white70),
              cellMargin: const EdgeInsets.all(3),
              defaultTextStyle: const TextStyle(fontSize: 13),
              cellPadding: EdgeInsets.zero,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                final text = '${day.year}年${day.month}月';
                return Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: pickMonth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            text,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 20,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              defaultBuilder: (context, day, _) =>
                  _buildCell(day, summaries),
              todayBuilder: (context, day, _) => _buildCell(
                day,
                summaries,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
              ),
              selectedBuilder: (context, day, _) => _buildCell(
                day,
                summaries,
                fill: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.35),
              ),
            ),
          ),
          Expanded(
            child: isLockedPastMonth
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Card(
                        color: const Color(0xFF1B1E28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.amber.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.history,
                                size: 40,
                                color: Colors.amber,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${focusedDay.value.year}年${focusedDay.value.month}月の記録（3ヶ月以上前）',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'PROプランに加入すると、3ヶ月以上前のすべての過去データと詳細分析が解放されます。',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => showPaywallSheet(
                                  context,
                                  featureTriggerTitle: '全期間の過去データ閲覧',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'PROで過去の記録を見る（¥250/月）',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: MonthSummaryPanel(monthAnchor: focusedDay.value),
                  ),
          ),
        ],
      ),
    );
  }

  static Widget _buildCell(
    DateTime day,
    Map<DateTime, DayWorkoutSummary> summaries, {
    BoxBorder? border,
    Color? fill,
  }) {
    final key = WorkoutRepository.normalizeDate(day);
    final summary = summaries[key];
    final groups = summary?.muscleGroups ?? {};

    return CalendarDayCell(
      day: day.day,
      groups: groups,
      hasCardio: summary?.hasCardio ?? false,
      border: border,
      fill: fill,
    );
  }
}
