import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/services/database_service.dart';

enum ThemeType { system, light, dark, amoled }

class ThemeState {
  final ThemeType themeType;
  final ThemeMode themeMode;

  const ThemeState({required this.themeType, required this.themeMode});

  factory ThemeState.initial() => const ThemeState(
    themeType: ThemeType.system,
    themeMode: ThemeMode.system,
  );
}

@lazySingleton
class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeBoxName = 'settings';
  static const String _themeKey = 'theme_type';
  final DatabaseService _dbService;

  ThemeCubit(this._dbService) : super(ThemeState.initial()) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeIndex = _dbService.read(
      _themeBoxName,
      _themeKey,
      defaultValue: ThemeType.system.index,
    );
    final themeType = ThemeType.values[themeIndex];
    setTheme(themeType);
  }

  void setTheme(ThemeType themeType) {
    ThemeMode mode;
    switch (themeType) {
      case ThemeType.system:
        mode = ThemeMode.system;
        break;
      case ThemeType.light:
        mode = ThemeMode.light;
        break;
      case ThemeType.dark:
      case ThemeType.amoled:
        mode = ThemeMode.dark;
        break;
    }

    emit(ThemeState(themeType: themeType, themeMode: mode));
    _dbService.write(_themeBoxName, _themeKey, themeType.index);
  }
}
