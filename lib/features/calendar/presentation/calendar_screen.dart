import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:progressive_lift/data/repositories/workout_repository.dart';
import 'package:progressive_lift/features/calendar/presentation/day_workout_sheet.dart';
import 'package:progressive_lift/features/calendar/presentation/widgets/month_summary_panel.dart';
import 'package:progressive_lift/providers/app_providers.dart';
import 'package:progressive_lift/shared/widgets/calendar_day_cell.dart';
import 'package:progressive_lift/shared/widgets/muscle_group_legend.dart';

class CalendarScreen extends HookConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusedDay = useState(DateTime.now());
    final selectedDay = useState<DateTime?>(DateTime.now());

    final summariesAsync = ref.watch(
      calendarSummariesProvider(focusedDay.value),
    );

    final summaries = summariesAsync.maybeWhen(
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
          IconButton(
            tooltip: 'プレミアム切替（デモ）',
            onPressed: () => ref.read(premiumToggleProvider.notifier).toggle(),
            icon: Icon(
              ref.watch(premiumToggleProvider)
                  ? Icons.workspace_premium
                  : Icons.workspace_premium_outlined,
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
            child: SingleChildScrollView(
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
