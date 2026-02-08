import 'package:equatable/equatable.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

/// Events for [SettingsBloc] to manage user preferences.
sealed class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

/// Triggers loading of all settings from storage.
final class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

/// Toggles biometric authentication preference.
final class ToggleBiometrics extends SettingsEvent {
  final bool value;
  const ToggleBiometrics(this.value);
  @override
  List<Object> get props => [value];
}

/// Updates the entire password generation settings.
final class UpdatePasswordSettings extends SettingsEvent {
  final PasswordGenerationSettings settings;
  const UpdatePasswordSettings(this.settings);
  @override
  List<Object> get props => [settings];
}

/// Updates a single password generation strategy.
final class UpdateStrategy extends SettingsEvent {
  final PasswordGenerationStrategy strategy;
  const UpdateStrategy(this.strategy);
  @override
  List<Object> get props => [strategy];
}

/// Adds a new password generation strategy.
final class AddStrategy extends SettingsEvent {
  final PasswordGenerationStrategy strategy;
  const AddStrategy(this.strategy);
  @override
  List<Object> get props => [strategy];
}

/// Deletes a password generation strategy by ID.
final class DeleteStrategy extends SettingsEvent {
  final String id;
  const DeleteStrategy(this.id);
  @override
  List<Object> get props => [id];
}

/// Sets the default password generation strategy.
final class SetDefaultStrategy extends SettingsEvent {
  final String id;
  const SetDefaultStrategy(this.id);
  @override
  List<Object> get props => [id];
}
