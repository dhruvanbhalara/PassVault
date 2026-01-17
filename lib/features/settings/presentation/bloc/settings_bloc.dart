import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_event.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_state.dart';

export 'settings_event.dart';
export 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;

  SettingsBloc(this._settingsRepository) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleBiometrics>(_onToggleBiometrics);
    on<UpdatePasswordSettings>(_onUpdatePasswordSettings);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final biometricsResult = _settingsRepository.getBiometricsEnabled();
    final useBiometrics = biometricsResult.fold(
      (failure) => false,
      (enabled) => enabled,
    );

    final settingsResult = _settingsRepository.getPasswordGenerationSettings();
    final passwordSettings = settingsResult.fold(
      (failure) => const PasswordGenerationSettings(),
      (settings) => settings,
    );

    emit(
      state.copyWith(
        useBiometrics: useBiometrics,
        passwordSettings: passwordSettings,
      ),
    );
  }

  Future<void> _onToggleBiometrics(
    ToggleBiometrics event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setBiometricsEnabled(event.value);
    emit(state.copyWith(useBiometrics: event.value));
  }

  Future<void> _onUpdatePasswordSettings(
    UpdatePasswordSettings event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.savePasswordGenerationSettings(event.settings);
    emit(state.copyWith(passwordSettings: event.settings));
  }
}
