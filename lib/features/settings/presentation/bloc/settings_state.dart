import 'package:equatable/equatable.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

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
  const SettingsInitial({
    super.useBiometrics = false,
    super.passwordSettings = const PasswordGenerationSettings(
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
  });
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
  final String errorMessage;

  const SettingsFailure({
    required this.errorMessage,
    required super.useBiometrics,
    required super.passwordSettings,
  });

  @override
  List<Object?> get props => [...super.props, errorMessage];
}
