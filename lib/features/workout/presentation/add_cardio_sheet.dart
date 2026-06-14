import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/core/enums/cardio_record_mode.dart';
import 'package:progressive_lift/core/enums/cardio_type.dart';
import 'package:progressive_lift/data/models/cardio_record.dart';
import 'package:progressive_lift/domain/services/cardio_interval_calculator.dart';
import 'package:progressive_lift/providers/app_providers.dart';

Future<void> showAddCardioSheet(
  BuildContext context, {
  required int sessionId,
  CardioRecord? existing,
  required VoidCallback onSaved,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _AddCardioSheet(
      sessionId: sessionId,
      existing: existing,
      onSaved: onSaved,
    ),
  );
}

class _AddCardioSheet extends HookConsumerWidget {
  const _AddCardioSheet({
    required this.sessionId,
    this.existing,
    required this.onSaved,
  });

  final int sessionId;
  final CardioRecord? existing;
  final VoidCallback onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = useState(existing?.type ?? CardioType.run);
    final selectedMode = useState(
      existing?.mode ?? CardioRecordMode.duration,
    );
    final durationCtrl = useTextEditingController(
      text: existing != null && existing!.mode == CardioRecordMode.duration
          ? existing!.durationMinutes.toString()
          : '',
    );
    final roundsCtrl = useTextEditingController(
      text: existing?.intervalRounds?.toString() ?? '',
    );
    final workCtrl = useTextEditingController(
      text: existing?.intervalWorkSeconds?.toString() ?? '',
    );
    final restCtrl = useTextEditingController(
      text: existing?.intervalRestSeconds?.toString() ?? '',
    );
    final memoCtrl = useTextEditingController(text: existing?.memo ?? '');

    useListenable(durationCtrl);
    useListenable(roundsCtrl);
    useListenable(workCtrl);
    useListenable(restCtrl);

    int? intervalPreview() {
      final rounds = int.tryParse(roundsCtrl.text);
      final work = int.tryParse(workCtrl.text);
      final rest = int.tryParse(restCtrl.text);
      if (rounds == null ||
          work == null ||
          rest == null ||
          rounds <= 0 ||
          work <= 0 ||
          rest < 0) {
        return null;
      }
      return CardioIntervalCalculator.totalMinutesCeil(
        rounds: rounds,
        workSeconds: work,
        restSeconds: rest,
      );
    }

    Future<void> save() async {
      final repo = await ref.read(workoutRepositoryProvider.future);
      final memo = memoCtrl.text;

      if (selectedMode.value == CardioRecordMode.duration) {
        final minutes = int.tryParse(durationCtrl.text);
        if (minutes == null || minutes <= 0) return;

        if (existing != null) {
          await repo.updateCardio(
            id: existing!.id,
            type: selectedType.value,
            mode: CardioRecordMode.duration,
            durationMinutes: minutes,
            memo: memo,
          );
        } else {
          await repo.addCardio(
            sessionId: sessionId,
            type: selectedType.value,
            mode: CardioRecordMode.duration,
            durationMinutes: minutes,
            memo: memo,
          );
        }
      } else {
        final rounds = int.tryParse(roundsCtrl.text);
        final work = int.tryParse(workCtrl.text);
        final rest = int.tryParse(restCtrl.text);
        if (rounds == null ||
            work == null ||
            rest == null ||
            rounds <= 0 ||
            work <= 0 ||
            rest < 0) {
          return;
        }

        final minutes = CardioIntervalCalculator.totalMinutesCeil(
          rounds: rounds,
          workSeconds: work,
          restSeconds: rest,
        );
        if (minutes <= 0) return;

        if (existing != null) {
          await repo.updateCardio(
            id: existing!.id,
            type: selectedType.value,
            mode: CardioRecordMode.interval,
            durationMinutes: minutes,
            intervalRounds: rounds,
            intervalWorkSeconds: work,
            intervalRestSeconds: rest,
            memo: memo,
          );
        } else {
          await repo.addCardio(
            sessionId: sessionId,
            type: selectedType.value,
            mode: CardioRecordMode.interval,
            durationMinutes: minutes,
            intervalRounds: rounds,
            intervalWorkSeconds: work,
            intervalRestSeconds: rest,
            memo: memo,
          );
        }
      }

      if (!context.mounted) return;
      Navigator.pop(context);
      onSaved();
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              existing != null ? '有酸素を編集' : '有酸素を記録',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: CardioType.values.map((t) {
                final selected = selectedType.value == t;
                return FilterChip(
                  label: Text(t.label),
                  selected: selected,
                  avatar: Icon(t.icon, size: 16),
                  onSelected: (_) => selectedType.value = t,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            SegmentedButton<CardioRecordMode>(
              segments: CardioRecordMode.values
                  .map(
                    (mode) => ButtonSegment(
                      value: mode,
                      label: Text(mode.label),
                    ),
                  )
                  .toList(),
              selected: {selectedMode.value},
              onSelectionChanged: (values) {
                selectedMode.value = values.first;
              },
            ),
            const SizedBox(height: 8),
            Text(
              selectedMode.value == CardioRecordMode.interval
                  ? 'HIITなど：セット数と運動/休息時間で記録'
                  : 'LSDやジョギングなど：合計時間で記録',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.45),
              ),
            ),
            const SizedBox(height: 16),
            if (selectedMode.value == CardioRecordMode.duration) ...[
              TextField(
                controller: durationCtrl,
                keyboardType: TextInputType.number,
                autofocus: existing == null,
                decoration: const InputDecoration(
                  labelText: '時間',
                  hintText: '例: 25',
                  suffixText: '分',
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: roundsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'セット',
                        hintText: '8',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: workCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '運動',
                        hintText: '30',
                        suffixText: '秒',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: restCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '休息',
                        hintText: '30',
                        suffixText: '秒',
                      ),
                    ),
                  ),
                ],
              ),
              if (intervalPreview() != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '合計 約${intervalPreview()}分',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: memoCtrl,
              decoration: InputDecoration(
                labelText: 'メモ（任意）',
                hintText: selectedMode.value == CardioRecordMode.interval
                    ? '例: バーピー / スプリント'
                    : '例: 坂道、LSD など',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: save,
              child: Text(existing != null ? '保存' : '記録'),
            ),
          ],
        ),
      ),
    );
  }
}
