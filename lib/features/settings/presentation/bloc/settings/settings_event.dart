part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class ToggleBiometrics extends SettingsEvent {
  final bool value;
  const ToggleBiometrics(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdatePasswordSettings extends SettingsEvent {
  final PasswordGenerationSettings settings;
  const UpdatePasswordSettings(this.settings);

  @override
  List<Object?> get props => [settings];
}

class UpdateStrategy extends SettingsEvent {
  final PasswordGenerationStrategy strategy;
  const UpdateStrategy(this.strategy);

  @override
  List<Object?> get props => [strategy];
}

class AddStrategy extends SettingsEvent {
  final PasswordGenerationStrategy strategy;
  const AddStrategy(this.strategy);

  @override
  List<Object?> get props => [strategy];
}

class DeleteStrategy extends SettingsEvent {
  final String id;
  const DeleteStrategy(this.id);

  @override
  List<Object?> get props => [id];
}

class SetDefaultStrategy extends SettingsEvent {
  final String id;
  const SetDefaultStrategy(this.id);

  @override
  List<Object?> get props => [id];
}
