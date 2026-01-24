import 'package:equatable/equatable.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';

/// Exhaustive error types for Data Migration operations.
enum DataMigrationError {
  fileNotFound,
  invalidFormat,
  wrongPassword,
  permissionDenied,
  noDataToExport,
  storageFull,
  importFailed,
  cancelled,
  unknown,
}

/// Type-safe Sealed States for ImportExportBloc.
sealed class ImportExportState extends Equatable {
  const ImportExportState();

  @override
  List<Object?> get props => [];
}

/// Initial state - waiting for user action.
class ImportExportInitial extends ImportExportState {
  const ImportExportInitial();
}

/// Operation in progress.
class ImportExportLoading extends ImportExportState {
  final String message;

  const ImportExportLoading(this.message);

  @override
  List<Object?> get props => [message];
}

/// Successful Import with no duplicates.
class ImportSuccess extends ImportExportState {
  final int count;
  const ImportSuccess(this.count);

  @override
  List<Object?> get props => [count];
}

/// Successful Export.
class ExportSuccess extends ImportExportState {
  final String destination;
  const ExportSuccess(this.destination);

  @override
  List<Object?> get props => [destination];
}

/// Successful Database Wipe (Debug feature).
class ClearDatabaseSuccess extends ImportExportState {
  const ClearDatabaseSuccess();
}

/// Duplicates detected - requires user intervention.
class DuplicatesDetected extends ImportExportState {
  final List<DuplicatePasswordEntry> duplicates;
  final int successfulImports;

  const DuplicatesDetected({
    required this.duplicates,
    required this.successfulImports,
  });

  @override
  List<Object?> get props => [duplicates, successfulImports];
}

/// State after duplicates have been successfully resolved.
class DuplicatesResolved extends ImportExportState {
  final int totalResolved;
  final int totalImported;

  const DuplicatesResolved({
    required this.totalResolved,
    required this.totalImported,
  });

  @override
  List<Object?> get props => [totalResolved, totalImported];
}

/// Operation failed.
class ImportExportFailure extends ImportExportState {
  final DataMigrationError error;
  final String message;

  const ImportExportFailure(this.error, this.message);

  @override
  List<Object?> get props => [error, message];
}
