import 'package:flutter/material.dart';

enum MuscleGroup {
  chest('胸', Color(0xFFE57373)),
  back('背中', Color(0xFF64B5F6)),
  legs('脚', Color(0xFF81C784)),
  shoulders('肩', Color(0xFFFFB74D)),
  arms('腕', Color(0xFFBA68C8)), // legacy（移行用・UI非表示）
  core('体幹', Color(0xFF4DB6AC)),
  biceps('二頭', Color(0xFFCE93D8)),
  triceps('三頭', Color(0xFFAB47BC));

  const MuscleGroup(this.label, this.color);
  final String label;
  final Color color;

  /// UIで選択・表示する部位
  static const selectable = [
    MuscleGroup.chest,
    MuscleGroup.back,
    MuscleGroup.legs,
    MuscleGroup.shoulders,
    MuscleGroup.core,
    MuscleGroup.biceps,
    MuscleGroup.triceps,
  ];

  bool get isLegacy => this == MuscleGroup.arms;

  /// 表示用（旧「腕」は二頭にフォールバック）
  MuscleGroup get displayGroup => isLegacy ? MuscleGroup.biceps : this;
}
