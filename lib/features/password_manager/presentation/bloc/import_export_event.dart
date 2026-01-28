import 'package:equatable/equatable.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';

/// Unified Events for Data Migration (Import, Export, Maintenance).
sealed class ImportExportEvent extends Equatable {
  const ImportExportEvent();

  @override
  List<Object?> get props => [];
}

/// Generic Data Export (CSV or JSON).
class ExportDataEvent extends ImportExportEvent {
  final bool isJson;

  const ExportDataEvent({required this.isJson});

  @override
  List<Object?> get props => [isJson];
}

/// Generic Data Import (CSV or JSON).
class ImportDataEvent extends ImportExportEvent {
  final bool isJson;

  const ImportDataEvent({required this.isJson});

  @override
  List<Object?> get props => [isJson];
}

/// Export with Password-Based Encryption (.pvault).
class ExportEncryptedEvent extends ImportExportEvent {
  final String password;

  const ExportEncryptedEvent(this.password);

  @override
  List<Object?> get props => [password];
}

/// Import from Password-Based Encrypted file (.pvault).
class ImportEncryptedEvent extends ImportExportEvent {
  final String password;
  final String? filePath; // Optional: triggers picker if null

  const ImportEncryptedEvent({required this.password, this.filePath});

  @override
  List<Object?> get props => [password, filePath];
}

/// Resolve detected duplicates from a previous import.
class ResolveDuplicatesEvent extends ImportExportEvent {
  final List<DuplicatePasswordEntry> resolutions;

  const ResolveDuplicatesEvent(this.resolutions);

  @override
  List<Object?> get props => [resolutions];
}

/// Clear all password entries from the database (Debug/Maintenance only).
class ClearDatabaseEvent extends ImportExportEvent {
  const ClearDatabaseEvent();
}

/// Reset temporary status/success/error/duplicates in state.
/// Prevents re-triggering logic on subsequent state updates.
class ResetMigrationStatus extends ImportExportEvent {
  const ResetMigrationStatus();
}
