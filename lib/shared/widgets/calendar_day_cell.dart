import 'package:flutter/material.dart';
import 'package:progressive_lift/core/enums/muscle_group.dart';
import 'package:progressive_lift/core/theme/cardio_style.dart';
import 'package:progressive_lift/shared/widgets/muscle_group_dots.dart';

/// カレンダー日付セル
/// 有酸素あり: 日付 + N部位行 + ドット行 + 有酸素行（3段）
/// 有酸素なし: 日付 + MuscleGroupDots
class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
    required this.day,
    required this.groups,
    this.hasCardio = false,
    this.border,
    this.fill,
  });

  final int day;
  final Set<MuscleGroup> groups;
  final bool hasCardio;
  final BoxBorder? border;
  final Color? fill;

  static const _indicatorRowHeight = 11.0;

  @override
  Widget build(BuildContext context) {
    final sorted =
        MuscleGroup.selectable.where((g) => groups.contains(g)).toList();
    final multiPart = sorted.length >= 2;
    final hasGroups = sorted.isNotEmpty;

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: fill ??
            (multiPart ? Colors.white.withValues(alpha: 0.04) : null),
        border: border,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 13,
                height: 1,
                fontWeight: multiPart ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 1),
            if (hasCardio)
              _ThreeRowIndicators(
                sorted: sorted,
                hasGroups: hasGroups,
              )
            else if (hasGroups)
              MuscleGroupDots(groups: groups, dotSize: 7)
            else
              const SizedBox(height: 9),
          ],
        ),
      ),
    );
  }
}

class _ThreeRowIndicators extends StatelessWidget {
  const _ThreeRowIndicators({
    required this.sorted,
    required this.hasGroups,
  });

  final List<MuscleGroup> sorted;
  final bool hasGroups;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: CalendarDayCell._indicatorRowHeight,
          child: Center(
            child: hasGroups
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${sorted.length}部位',
                      style: const TextStyle(
                        fontSize: 7,
                        height: 1,
                        color: Colors.white70,
                      ),
                    ),
                  )
                : null,
          ),
        ),
        SizedBox(
          height: CalendarDayCell._indicatorRowHeight,
          child: Center(
            child: hasGroups
                ? MuscleGroupDots(
                    groups: sorted.toSet(),
                    dotSize: 6,
                    showBadge: false,
                  )
                : null,
          ),
        ),
        SizedBox(
          height: CalendarDayCell._indicatorRowHeight,
          child: Center(
            child: Icon(
              CardioStyle.icon,
              size: 9,
              color: CardioStyle.accent,
            ),
          ),
        ),
      ],
    );
  }
}
