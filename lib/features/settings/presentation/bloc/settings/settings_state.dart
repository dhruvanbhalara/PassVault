part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  final bool useBiometrics;
  final bool useScreenPrivacy;
  final PasswordGenerationSettings passwordSettings;

  const SettingsState({
    required this.useBiometrics,
    required this.useScreenPrivacy,
    required this.passwordSettings,
  });

  @override
  List<Object?> get props => [
    useBiometrics,
    useScreenPrivacy,
    passwordSettings,
  ];
}

final class SettingsInitial extends SettingsState {
  SettingsInitial()
    : super(
        useBiometrics: false,
        useScreenPrivacy: true,
        passwordSettings: PasswordGenerationSettings.initial(),
      );
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading({
    required super.useBiometrics,
    required super.useScreenPrivacy,
    required super.passwordSettings,
  });
}

final class SettingsLoaded extends SettingsState {
  const SettingsLoaded({
    required super.useBiometrics,
    required super.useScreenPrivacy,
    required super.passwordSettings,
  });
}

final class SettingsFailure extends SettingsState {
  final String message;
  const SettingsFailure({
    required super.useBiometrics,
    required super.useScreenPrivacy,
    required super.passwordSettings,
    required this.message,
  });

  @override
  List<Object?> get props => [
    useBiometrics,
    useScreenPrivacy,
    passwordSettings,
    message,
  ];
}
