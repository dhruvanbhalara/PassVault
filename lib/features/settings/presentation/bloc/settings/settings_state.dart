part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  final bool useBiometrics;
  final PasswordGenerationSettings passwordSettings;

  const SettingsState({
    required this.useBiometrics,
    required this.passwordSettings,
  });

  @override
  List<Object?> get props => [useBiometrics, passwordSettings];
}

final class SettingsInitial extends SettingsState {
  SettingsInitial()
    : super(
        useBiometrics: false,
        passwordSettings: PasswordGenerationSettings.initial(),
      );
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading({
    required super.useBiometrics,
    required super.passwordSettings,
  });
}

final class SettingsLoaded extends SettingsState {
  const SettingsLoaded({
    required super.useBiometrics,
    required super.passwordSettings,
  });
}

final class SettingsFailure extends SettingsState {
  final String message;
  const SettingsFailure({
    required super.useBiometrics,
    required super.passwordSettings,
    required this.message,
  });

  @override
  List<Object?> get props => [useBiometrics, passwordSettings, message];
}
