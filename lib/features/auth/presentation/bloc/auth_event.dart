import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {}

class AuthPasswordLoginRequested extends AuthEvent {
  final String password;

  const AuthPasswordLoginRequested(this.password);

  @override
  List<Object> get props => [password];
}
