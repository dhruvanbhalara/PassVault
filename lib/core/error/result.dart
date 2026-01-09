import 'package:equatable/equatable.dart';
import 'package:passvault/core/error/failures.dart';

/// A functional Result type to handle Success and Failure cases.
///
/// Mandated by enterprise coding standards for all Repository and UseCase returns.
sealed class Result<T> extends Equatable {
  const Result();

  @override
  List<Object?> get props => [];

  /// Helper to check if result is success.
  bool get isSuccess => this is Success<T>;

  /// Helper to check if result is failure.
  bool get isFailure => this is Error<T>;

  /// fold helper to handle both cases.
  R fold<R>(R Function(Failure failure) onError, R Function(T data) onSuccess) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onError((this as Error<T>).failure);
    }
  }
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);

  @override
  List<Object?> get props => [failure];
}
