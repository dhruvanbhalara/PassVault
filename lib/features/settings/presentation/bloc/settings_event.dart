import 'package:equatable/equatable.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleBiometrics extends SettingsEvent {
  final bool value;
  const ToggleBiometrics(this.value);
  @override
  List<Object> get props => [value];
}

class UpdatePasswordSettings extends SettingsEvent {
  final PasswordGenerationSettings settings;
  const UpdatePasswordSettings(this.settings);
  @override
  List<Object> get props => [settings];
}
