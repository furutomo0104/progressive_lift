import 'package:flutter/material.dart';

enum MuscleGroup {
  chest('胸', Color(0xFFE57373)),
  back('背中', Color(0xFF64B5F6)),
  legs('脚', Color(0xFF81C784)),
  shoulders('肩', Color(0xFFFFB74D)),
  arms('腕', Color(0xFFBA68C8)),
  core('体幹', Color(0xFF4DB6AC));

  const MuscleGroup(this.label, this.color);
  final String label;
  final Color color;
}
