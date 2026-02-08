import 'package:equatable/equatable.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

enum AddEditStatus { initial, generated, saving, success, failure }

class AddEditPasswordState extends Equatable {
  final AddEditStatus status;
  final String generatedPassword;
  final double strength;
  final String? errorMessage;
  final PasswordGenerationSettings? settings;

  const AddEditPasswordState({
    this.status = AddEditStatus.initial,
    this.generatedPassword = '',
    this.strength = 0.0,
    this.errorMessage,
    this.settings,
  });

  AddEditPasswordState copyWith({
    AddEditStatus? status,
    String? generatedPassword,
    double? strength,
    String? errorMessage,
    PasswordGenerationSettings? settings,
  }) {
    return AddEditPasswordState(
      status: status ?? this.status,
      generatedPassword: generatedPassword ?? this.generatedPassword,
      strength: strength ?? this.strength,
      errorMessage: errorMessage ?? this.errorMessage,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [
    status,
    generatedPassword,
    strength,
    errorMessage,
    settings,
  ];
}
