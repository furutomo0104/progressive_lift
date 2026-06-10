import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:progressive_lift/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ja');
  runApp(const ProgressiveLiftApp());
}
