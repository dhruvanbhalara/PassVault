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

/// Failure during password import/export operations.
class ImportExportFailure extends Failure {
  const ImportExportFailure(super.message);
}

/// Failure when reading import file.
class FileReadFailure extends ImportExportFailure {
  const FileReadFailure(super.message);
}

/// Failure when CSV format is invalid.
class InvalidFormatFailure extends ImportExportFailure {
  const InvalidFormatFailure(super.message);
}

/// Failure during CSV parsing.
class ParsingFailure extends ImportExportFailure {
  const ParsingFailure(super.message);
}

/// No valid data found in import file.
class NoDataFoundFailure extends ImportExportFailure {
  const NoDataFoundFailure(super.message);
}
