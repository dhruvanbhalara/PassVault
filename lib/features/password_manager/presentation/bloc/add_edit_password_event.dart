import 'package:equatable/equatable.dart';

sealed class AddEditPasswordEvent extends Equatable {
  const AddEditPasswordEvent();
  @override
  List<Object?> get props => [];
}

final class GenerateStrongPassword extends AddEditPasswordEvent {}

final class PasswordChanged extends AddEditPasswordEvent {
  final String password;
  const PasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}
