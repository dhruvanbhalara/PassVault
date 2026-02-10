import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/domain/usecases/get_theme_usecase.dart';
import 'package:passvault/features/settings/domain/usecases/set_theme_usecase.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_event.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_state.dart';

export 'theme_event.dart';
export 'theme_state.dart';

@lazySingleton
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetThemeUseCase _getThemeUseCase;
  final SetThemeUseCase _setThemeUseCase;

  ThemeBloc(this._getThemeUseCase, this._setThemeUseCase)
    : super(
        const ThemeLoaded(
          themeType: ThemeType.system,
          themeMode: ThemeMode.system,
        ),
      ) {
    on<ThemeInitialized>(_onThemeInitialized);
    on<ThemeChanged>(_onThemeChanged);

    add(const ThemeInitialized());
  }

  void _onThemeInitialized(ThemeInitialized event, Emitter<ThemeState> emit) {
    final result = _getThemeUseCase();

    if (result is Success<ThemeType>) {
      _applyTheme(result.data, emit);
    } else {
      _applyTheme(ThemeType.system, emit);
    }
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    _applyTheme(event.themeType, emit);
    await _setThemeUseCase(event.themeType);
  }

  void _applyTheme(ThemeType themeType, Emitter<ThemeState> emit) {
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

    emit(ThemeLoaded(themeType: themeType, themeMode: mode));
  }
}
