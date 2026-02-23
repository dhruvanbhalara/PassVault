part of 'import_export_bloc.dart';

sealed class ImportExportState extends Equatable {
  const ImportExportState();

  @override
  List<Object?> get props => [];
}

class ImportExportInitial extends ImportExportState {
  const ImportExportInitial();
}

class ImportExportLoading extends ImportExportState {
  const ImportExportLoading();
}

class ExportSuccess extends ImportExportState {
  final String filePath;
  const ExportSuccess(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class ImportEncryptedFileSelected extends ImportExportState {
  final String filePath;
  const ImportEncryptedFileSelected(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

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

class ImportSuccess extends ImportExportState {
  final int totalImported;
  const ImportSuccess(this.totalImported);

  @override
  List<Object?> get props => [totalImported];
}

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

class ClearDatabaseSuccess extends ImportExportState {
  const ClearDatabaseSuccess();
}

enum DataMigrationError {
  unknown,
  invalidFormat,
  noDataToExport,
  wrongPassword,
  permissionDenied,
  fileNotFound,
  importFailed,
}

class ImportExportFailure extends ImportExportState {
  final DataMigrationError error;
  final String message;
  const ImportExportFailure(this.error, this.message);

  @override
  List<Object?> get props => [error, message];
}
