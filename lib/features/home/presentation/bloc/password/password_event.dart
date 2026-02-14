part of 'password_bloc.dart';

sealed class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object?> get props => [];
}

class LoadPasswords extends PasswordEvent {
  const LoadPasswords();
}

class AddPassword extends PasswordEvent {
  final PasswordEntry entry;
  const AddPassword(this.entry);

  @override
  List<Object?> get props => [entry];
}

class UpdatePassword extends PasswordEvent {
  final PasswordEntry entry;
  const UpdatePassword(this.entry);

  @override
  List<Object?> get props => [entry];
}

class DeletePassword extends PasswordEvent {
  final String id;
  const DeletePassword(this.id);

  @override
  List<Object?> get props => [id];
}
