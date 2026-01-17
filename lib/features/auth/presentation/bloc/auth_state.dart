import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

enum AuthError { none, biometricsNotAvailable, authFailed }

class AuthUnauthenticated extends AuthState {
  final AuthError error;
  const AuthUnauthenticated({this.error = AuthError.none});

  @override
  List<Object> get props => [error];
}
