import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// 左スワイプで削除ボタンを表示し、タップで即削除
class SwipeDeleteTile extends StatelessWidget {
  const SwipeDeleteTile({
    super.key,
    required this.child,
    required this.onDelete,
    this.groupTag,
  });

  final Widget child;
  final VoidCallback onDelete;
  final String? groupTag;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      groupTag: groupTag,
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.22,
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: const Color(0xFFE53935),
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: '削除',
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      child: child,
    );
  }
}
