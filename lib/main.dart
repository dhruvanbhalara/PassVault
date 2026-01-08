import 'package:flutter/material.dart';
import 'package:passvault/core/di/injection.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DI - this also initializes encrypted Hive boxes
  await configureDependencies();

  runApp(const PassVaultApp());
}
