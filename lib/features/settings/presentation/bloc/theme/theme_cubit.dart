import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/settings/domain/usecases/get_theme_usecase.dart';
import 'package:passvault/features/settings/domain/usecases/set_theme_usecase.dart';

enum ThemeType { system, light, dark, amoled }

class ThemeState extends Equatable {
  final ThemeType themeType;
  final ThemeMode themeMode;

  const ThemeState({required this.themeType, required this.themeMode});

  factory ThemeState.initial() => const ThemeState(
    themeType: ThemeType.system,
    themeMode: ThemeMode.system,
  );

  @override
  List<Object> get props => [themeType, themeMode];
}

@lazySingleton
class ThemeCubit extends Cubit<ThemeState> {
  final GetThemeUseCase _getThemeUseCase;
  final SetThemeUseCase _setThemeUseCase;

  ThemeCubit(this._getThemeUseCase, this._setThemeUseCase)
    : super(ThemeState.initial()) {
    _loadTheme();
  }

  void _loadTheme() {
    final result = _getThemeUseCase();

    if (result is Success<ThemeType>) {
      setTheme(result.data);
    } else {
      setTheme(ThemeType.system);
    }
  }

  Future<void> setTheme(ThemeType themeType) async {
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
    await _setThemeUseCase(themeType);
  }
}
