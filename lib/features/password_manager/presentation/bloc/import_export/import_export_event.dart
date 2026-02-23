part of 'import_export_bloc.dart';

sealed class ImportExportEvent extends Equatable {
  const ImportExportEvent();

  @override
  List<Object?> get props => [];
}

class ExportDataEvent extends ImportExportEvent {
  final bool isJson;
  const ExportDataEvent({this.isJson = true});

  @override
  List<Object?> get props => [isJson];
}

class ExportEncryptedEvent extends ImportExportEvent {
  final String password;
  const ExportEncryptedEvent(this.password);

  @override
  List<Object?> get props => [password];
}

class PrepareImportFromFileEvent extends ImportExportEvent {
  const PrepareImportFromFileEvent();
}

class ImportEncryptedEvent extends ImportExportEvent {
  final String password;
  final String? filePath;
  const ImportEncryptedEvent(this.password, {this.filePath});

  @override
  List<Object?> get props => [password, filePath];
}

class ResolveDuplicatesEvent extends ImportExportEvent {
  final List<DuplicatePasswordEntry> resolutions;
  const ResolveDuplicatesEvent(this.resolutions);

  @override
  List<Object?> get props => [resolutions];
}

class ClearDatabaseEvent extends ImportExportEvent {
  const ClearDatabaseEvent();
}

class ResetMigrationStatus extends ImportExportEvent {
  const ResetMigrationStatus();
}
