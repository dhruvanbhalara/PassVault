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

  SettingsBloc(this._settingsRepository) : super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleBiometrics>(_onToggleBiometrics);
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
        passwordSettings: state.passwordSettings,
      ),
    );

    final biometricsResult = _settingsRepository.getBiometricsEnabled();
    final useBiometrics = biometricsResult.fold(
      (failure) => false,
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
        passwordSettings: passwordSettings,
      ),
    );
  }

  Future<void> _onToggleBiometrics(
    ToggleBiometrics event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setBiometricsEnabled(event.value);
    emit(
      SettingsLoaded(
        useBiometrics: event.value,
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
        passwordSettings: newSettings,
      ),
    );
  }
}
