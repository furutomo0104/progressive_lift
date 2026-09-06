import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/features/ads/interstitial_ad_service.dart';
import 'package:progressive_lift/features/workout/presentation/workout_record_panel.dart';
import 'package:progressive_lift/providers/app_providers.dart';

Future<void> showDayWorkoutSheet(BuildContext context, DateTime day) async {
  final container = ProviderScope.containerOf(context);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(ctx).bottom,
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (_, __) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              behavior: HitTestBehavior.translucent,
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
        ),
      );
    },
  );

  // 記録シートを閉じたタイミング＝セッション区切りとしてインタースティシャルを試行
  if (!context.mounted) return;
  final isPro =
      container.read(proSubscriptionNotifierProvider).valueOrNull ?? false;
  await InterstitialAdService.instance.showIfAllowed(isPro: isPro);
}
