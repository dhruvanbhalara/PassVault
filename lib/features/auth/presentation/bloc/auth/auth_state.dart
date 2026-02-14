part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
}

enum AuthError { none, biometricsNotAvailable, authFailed }

class AuthUnauthenticated extends AuthState {
  final AuthError error;
  const AuthUnauthenticated({this.error = AuthError.none});

  @override
  List<Object> get props => [error];
}
