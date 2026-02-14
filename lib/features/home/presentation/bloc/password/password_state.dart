part of 'password_bloc.dart';

sealed class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object?> get props => [];
}

class PasswordInitial extends PasswordState {
  const PasswordInitial();
}

class PasswordLoading extends PasswordState {
  const PasswordLoading();
}

class PasswordLoaded extends PasswordState {
  final List<PasswordEntry> passwords;
  const PasswordLoaded(this.passwords);

  @override
  List<Object?> get props => [passwords];
}

class PasswordError extends PasswordState {
  final String message;
  const PasswordError(this.message);

  @override
  List<Object?> get props => [message];
}
