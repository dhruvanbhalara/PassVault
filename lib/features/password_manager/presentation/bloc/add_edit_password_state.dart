import 'package:equatable/equatable.dart';

enum AddEditStatus { initial, generated }

class AddEditPasswordState extends Equatable {
  final AddEditStatus status;
  final String generatedPassword;
  final double strength;

  const AddEditPasswordState({
    this.status = AddEditStatus.initial,
    this.generatedPassword = '',
    this.strength = 0.0,
  });

  AddEditPasswordState copyWith({
    AddEditStatus? status,
    String? generatedPassword,
    double? strength,
  }) {
    return AddEditPasswordState(
      status: status ?? this.status,
      generatedPassword: generatedPassword ?? this.generatedPassword,
      strength: strength ?? this.strength,
    );
  }

  @override
  List<Object?> get props => [status, generatedPassword, strength];
}
