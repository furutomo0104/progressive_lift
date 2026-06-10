import 'package:flutter/material.dart';
import 'package:progressive_lift/features/workout/presentation/workout_record_panel.dart';

Future<void> showDayWorkoutSheet(BuildContext context, DateTime day) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) {
      final maxHeight = MediaQuery.sizeOf(ctx).height * 0.88;
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (_, controller) {
          return SizedBox(
            height: maxHeight,
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: WorkoutRecordPanel(selectedDay: day),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
