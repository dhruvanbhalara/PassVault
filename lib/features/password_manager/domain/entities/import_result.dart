import 'package:equatable/equatable.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';

/// Result of a password import operation.
///
/// Contains statistics about the import process and any duplicates
/// that require user resolution.
class ImportResult extends Equatable {
  /// Total number of records found in the import file
  final int totalRecords;

  /// Number of passwords successfully imported without conflicts
  final int successfulImports;

  /// Number of imports that failed due to validation or parsing errors
  final int failedImports;

  /// List of duplicate entries requiring user resolution
  final List<DuplicatePasswordEntry> duplicateEntries;

  /// Error messages with row numbers for failed imports
  final List<String> errors;

  const ImportResult({
    required this.totalRecords,
    required this.successfulImports,
    required this.failedImports,
    required this.duplicateEntries,
    required this.errors,
  });

  /// Number of detected duplicates
  int get duplicateCount => duplicateEntries.length;

  /// Check if there are any duplicates requiring resolution
  bool get hasDuplicates => duplicateEntries.isNotEmpty;

  /// Check if import was completely successful (no failures or duplicates)
  bool get isCompleteSuccess =>
      failedImports == 0 && duplicateCount == 0 && successfulImports > 0;

  /// Check if there were any errors
  bool get hasErrors => errors.isNotEmpty;

  @override
  List<Object?> get props => [
    totalRecords,
    successfulImports,
    failedImports,
    duplicateEntries,
    errors,
  ];
}
