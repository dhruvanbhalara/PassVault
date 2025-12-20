import 'package:flutter/material.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/core/services/database_service.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  await getIt<DatabaseService>().init();

  runApp(const PassVaultApp());
}
