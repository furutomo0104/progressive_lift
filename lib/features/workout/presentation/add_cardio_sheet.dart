import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/core/enums/cardio_type.dart';
import 'package:progressive_lift/data/models/cardio_record.dart';
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
    final durationCtrl = useTextEditingController(
      text: existing?.durationMinutes.toString() ?? '30',
    );
    final memoCtrl = useTextEditingController(text: existing?.memo ?? '');

    Future<void> save() async {
      final minutes = int.tryParse(durationCtrl.text);
      if (minutes == null || minutes <= 0) return;

      final repo = await ref.read(workoutRepositoryProvider.future);
      if (existing != null) {
        await repo.updateCardio(
          id: existing!.id,
          type: selectedType.value,
          durationMinutes: minutes,
          memo: memoCtrl.text,
        );
      } else {
        await repo.addCardio(
          sessionId: sessionId,
          type: selectedType.value,
          durationMinutes: minutes,
          memo: memoCtrl.text,
        );
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
            TextField(
              controller: durationCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '時間',
                suffixText: '分',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: memoCtrl,
              decoration: const InputDecoration(
                labelText: 'メモ（任意）',
                hintText: '坂道、LSD など',
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
