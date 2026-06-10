import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/core/theme/app_theme.dart';
import 'package:progressive_lift/features/calendar/presentation/calendar_screen.dart';

class ProgressiveLiftApp extends StatelessWidget {
  const ProgressiveLiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Progressive Lift',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const CalendarScreen(),
      ),
    );
  }
}
