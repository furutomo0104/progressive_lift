import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExerciseSetInputRow extends StatelessWidget {
  const ExerciseSetInputRow({
    super.key,
    required this.setIndex,
    required this.weightController,
    required this.repsController,
    required this.onAdd,
  });

  final int setIndex;
  final TextEditingController weightController;
  final TextEditingController repsController;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 28,
          child: Text(
            '${setIndex + 1}',
            style: const TextStyle(color: Colors.white54),
          ),
        ),
        Expanded(
          child: TextField(
            controller: weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            decoration: const InputDecoration(
              labelText: 'kg',
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: repsController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'reps',
              isDense: true,
            ),
          ),
        ),
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.check_circle_outline),
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
