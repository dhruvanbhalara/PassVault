import 'package:equatable/equatable.dart';

/// Base class for all domain failures.
sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class SecurityFailure extends Failure {
  const SecurityFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String? message])
    : super(message ?? 'An unknown error occurred');
}
