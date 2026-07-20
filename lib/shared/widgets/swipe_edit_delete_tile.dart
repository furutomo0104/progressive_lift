import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// 左スワイプで修正・削除ボタンを表示
class SwipeEditDeleteTile extends StatelessWidget {
  const SwipeEditDeleteTile({
    super.key,
    required this.child,
    required this.onEdit,
    required this.onDelete,
    this.groupTag,
    this.editLabel = '修正',
  });

  final Widget child;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String? groupTag;
  final String editLabel;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      groupTag: groupTag,
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.44,
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: const Color(0xFF5C6BC0),
            foregroundColor: Colors.white,
            icon: Icons.swap_horiz,
            label: editLabel,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(8),
            ),
          ),
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: const Color(0xFFE53935),
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: '削除',
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(8),
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}
