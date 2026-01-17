import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/core/observers/app_bloc_observer.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register BLoC observer for debug logging
  Bloc.observer = AppBlocObserver();

  // Initialize DI - this also initializes encrypted Hive boxes
  await configureDependencies();

  runApp(const PassVaultApp());
}
