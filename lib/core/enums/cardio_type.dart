import 'package:flutter/material.dart';

enum CardioType {
  run('ラン', Icons.directions_run),
  walk('ウォーク', Icons.directions_walk),
  bike('バイク', Icons.directions_bike),
  elliptical('エアロバイク', Icons.fitness_center),
  other('その他', Icons.more_horiz);

  const CardioType(this.label, this.icon);
  final String label;
  final IconData icon;
}
