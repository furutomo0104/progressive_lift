import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progressive_lift/core/theme/cardio_style.dart';
import 'package:progressive_lift/data/models/cardio_record.dart';
import 'package:progressive_lift/features/workout/presentation/add_cardio_sheet.dart';
import 'package:progressive_lift/providers/app_providers.dart';
import 'package:progressive_lift/shared/widgets/swipe_delete_tile.dart';

class CardioSection extends HookConsumerWidget {
  const CardioSection({
    super.key,
    required this.sessionId,
    required this.records,
    required this.onChanged,
  });

  final int sessionId;
  final List<CardioRecord> records;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = useState(records.isNotEmpty);

    Future<void> deleteRecord(CardioRecord record) async {
      final repo = await ref.read(workoutRepositoryProvider.future);
      await repo.deleteCardio(record.id);
      onChanged();
    }

    Future<void> openSheet({CardioRecord? existing}) async {
      await showAddCardioSheet(
        context,
        sessionId: sessionId,
        existing: existing,
        onSaved: onChanged,
      );
    }

    return Card(
      margin: const EdgeInsets.only(top: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => expanded.value = !expanded.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    Icons.directions_run,
                    size: 20,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      '有酸素',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (records.isNotEmpty)
                    Text(
                      '${records.length}件',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    expanded.value ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white38,
                  ),
                ],
              ),
            ),
          ),
          if (expanded.value) ...[
            const Divider(height: 1),
            if (records.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'ラン・ウォークなどを記録できます',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 13,
                  ),
                ),
              )
            else
              ...records.map(
                (r) => SwipeDeleteTile(
                  groupTag: 'cardio-$sessionId',
                  onDelete: () => deleteRecord(r),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      r.type.icon,
                      color: CardioStyle.accent,
                      size: 22,
                    ),
                    title: Text('${r.type.label}  ${r.durationMinutes}分'),
                    subtitle: r.memo != null && r.memo!.isNotEmpty
                        ? Text(
                            r.memo!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () => openSheet(existing: r),
                    ),
                    onTap: () => openSheet(existing: r),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: OutlinedButton.icon(
                onPressed: () => openSheet(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('有酸素を追加'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
