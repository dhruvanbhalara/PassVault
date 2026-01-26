import 'package:equatable/equatable.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

enum SettingsStatus { initial, loading, success, failure }

enum SettingsError { none, unknown }

enum SettingsSuccess { none }

class SettingsState extends Equatable {
  final bool useBiometrics;
  final PasswordGenerationSettings passwordSettings;
  final SettingsStatus status;
  final SettingsError error;
  final SettingsSuccess success;

  const SettingsState({
    this.useBiometrics = false,
    this.passwordSettings = const PasswordGenerationSettings(
      strategies: [
        PasswordGenerationStrategy(
          id: 'default',
          name: 'Default',
          length: 16,
          useNumbers: true,
          useSpecialChars: true,
          useUppercase: true,
          useLowercase: true,
          excludeAmbiguousChars: false,
        ),
      ],
      defaultStrategyId: 'default',
    ),
    this.status = SettingsStatus.initial,
    this.error = SettingsError.none,
    this.success = SettingsSuccess.none,
  });

  SettingsState copyWith({
    bool? useBiometrics,
    PasswordGenerationSettings? passwordSettings,
    SettingsStatus? status,
    SettingsError? error,
    SettingsSuccess? success,
  }) {
    return SettingsState(
      useBiometrics: useBiometrics ?? this.useBiometrics,
      passwordSettings: passwordSettings ?? this.passwordSettings,
      status: status ?? this.status,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [
    useBiometrics,
    passwordSettings,
    status,
    error,
    success,
  ];
}
