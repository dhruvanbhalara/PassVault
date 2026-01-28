import 'package:equatable/equatable.dart';

enum AddEditStatus { initial, generated, saving, success, failure }

class AddEditPasswordState extends Equatable {
  final AddEditStatus status;
  final String generatedPassword;
  final double strength;
  final String? errorMessage;

  const AddEditPasswordState({
    this.status = AddEditStatus.initial,
    this.generatedPassword = '',
    this.strength = 0.0,
    this.errorMessage,
  });

  AddEditPasswordState copyWith({
    AddEditStatus? status,
    String? generatedPassword,
    double? strength,
    String? errorMessage,
  }) {
    return AddEditPasswordState(
      status: status ?? this.status,
      generatedPassword: generatedPassword ?? this.generatedPassword,
      strength: strength ?? this.strength,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    generatedPassword,
    strength,
    errorMessage,
  ];
}
