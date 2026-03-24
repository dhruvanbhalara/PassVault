import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/services/screen_privacy_service.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@lazySingleton
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;
  final ScreenPrivacyService _screenPrivacyService;

  SettingsBloc(this._settingsRepository, this._screenPrivacyService)
    : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleBiometrics>(_onToggleBiometrics);
    on<ToggleScreenPrivacy>(_onToggleScreenPrivacy);
    on<UpdatePasswordSettings>(_onUpdatePasswordSettings);
    on<UpdateStrategy>(_onUpdateStrategy);
    on<AddStrategy>(_onAddStrategy);
    on<DeleteStrategy>(_onDeleteStrategy);
    on<SetDefaultStrategy>(_onSetDefaultStrategy);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    emit(
      SettingsLoading(
        useBiometrics: state.useBiometrics,
        useScreenPrivacy: state.useScreenPrivacy,
        passwordSettings: state.passwordSettings,
      ),
    );

    final biometricsResult = _settingsRepository.getBiometricsEnabled();
    final useBiometrics = biometricsResult.fold(
      (failure) => false,
      (enabled) => enabled,
    );

    final screenPrivacyResult = _settingsRepository.getScreenPrivacyEnabled();
    final useScreenPrivacy = screenPrivacyResult.fold(
      (failure) => true,
      (enabled) => enabled,
    );

    final settingsResult = _settingsRepository.getPasswordGenerationSettings();
    final passwordSettings = settingsResult.fold(
      (failure) => PasswordGenerationSettings.initial(),
      (settings) => settings,
    );

    emit(
      SettingsLoaded(
        useBiometrics: useBiometrics,
        useScreenPrivacy: useScreenPrivacy,
        passwordSettings: passwordSettings,
      ),
    );

    // Apply the persisted privacy setting to the native platform layer.
    if (useScreenPrivacy) {
      _screenPrivacyService.enableProtection();
    } else {
      _screenPrivacyService.disableProtection();
    }
  }

  Future<void> _onToggleBiometrics(
    ToggleBiometrics event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setBiometricsEnabled(event.value);
    emit(
      SettingsLoaded(
        useBiometrics: event.value,
        useScreenPrivacy: state.useScreenPrivacy,
        passwordSettings: state.passwordSettings,
      ),
    );
  }

  Future<void> _onToggleScreenPrivacy(
    ToggleScreenPrivacy event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setScreenPrivacyEnabled(event.value);
    if (event.value) {
      await _screenPrivacyService.enableProtection();
    } else {
      await _screenPrivacyService.disableProtection();
    }
    emit(
      SettingsLoaded(
        useBiometrics: state.useBiometrics,
        useScreenPrivacy: event.value,
        passwordSettings: state.passwordSettings,
      ),
    );
  }

  Future<void> _onUpdatePasswordSettings(
    UpdatePasswordSettings event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.savePasswordGenerationSettings(event.settings);
    emit(
      SettingsLoaded(
        useBiometrics: state.useBiometrics,
        useScreenPrivacy: state.useScreenPrivacy,
        passwordSettings: event.settings,
      ),
    );
  }

  Future<void> _onUpdateStrategy(
    UpdateStrategy event,
    Emitter<SettingsState> emit,
  ) async {
    final strategies = state.passwordSettings.strategies.map((s) {
      return s.id == event.strategy.id ? event.strategy : s;
    }).toList();
    final newSettings = state.passwordSettings.copyWith(strategies: strategies);
    await _settingsRepository.savePasswordGenerationSettings(newSettings);
    emit(
      SettingsLoaded(
        useBiometrics: state.useBiometrics,
        useScreenPrivacy: state.useScreenPrivacy,
        passwordSettings: newSettings,
      ),
    );
  }

  Future<void> _onAddStrategy(
    AddStrategy event,
    Emitter<SettingsState> emit,
  ) async {
    final strategies = List<PasswordGenerationStrategy>.from(
      state.passwordSettings.strategies,
    )..add(event.strategy);
    final newSettings = state.passwordSettings.copyWith(strategies: strategies);
    await _settingsRepository.savePasswordGenerationSettings(newSettings);
    emit(
      SettingsLoaded(
        useBiometrics: state.useBiometrics,
        useScreenPrivacy: state.useScreenPrivacy,
        passwordSettings: newSettings,
      ),
    );
  }

  Future<void> _onDeleteStrategy(
    DeleteStrategy event,
    Emitter<SettingsState> emit,
  ) async {
    final strategies = state.passwordSettings.strategies
        .where((s) => s.id != event.id)
        .toList();

    // Ensure we don't delete the last strategy or current default
    if (strategies.isEmpty) return;

    var newDefaultId = state.passwordSettings.defaultStrategyId;
    if (event.id == newDefaultId) {
      newDefaultId = strategies.first.id;
    }

    final newSettings = state.passwordSettings.copyWith(
      strategies: strategies,
      defaultStrategyId: newDefaultId,
    );
    await _settingsRepository.savePasswordGenerationSettings(newSettings);
    emit(
      SettingsLoaded(
        useBiometrics: state.useBiometrics,
        useScreenPrivacy: state.useScreenPrivacy,
        passwordSettings: newSettings,
      ),
    );
  }

  Future<void> _onSetDefaultStrategy(
    SetDefaultStrategy event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings = state.passwordSettings.copyWith(
      defaultStrategyId: event.id,
    );
    await _settingsRepository.savePasswordGenerationSettings(newSettings);
    emit(
      SettingsLoaded(
        useBiometrics: state.useBiometrics,
        useScreenPrivacy: state.useScreenPrivacy,
        passwordSettings: newSettings,
      ),
    );
  }
}
