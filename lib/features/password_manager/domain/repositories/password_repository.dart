import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/import_result.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

abstract class PasswordRepository {
  Future<Result<List<PasswordEntry>>> getPasswords();
  Future<Result<void>> savePassword(PasswordEntry entry);
  Future<Result<void>> deletePassword(String id);

  /// Import passwords from a list of entries.
  /// Returns ImportResult with duplicates for user resolution.
  /// Duplicates are NOT automatically saved.
  Future<Result<ImportResult>> importPasswords(List<PasswordEntry> entries);

  /// Resolve duplicates based on user choices.
  /// Applies user's decisions: keep existing, replace with new, or keep both.
  Future<Result<void>> resolveDuplicates(
    List<DuplicatePasswordEntry> resolutions,
  );

  /// Export all passwords to CSV format.
  /// Returns CSV string with all password data (unencrypted).
  Future<Result<String>> exportPasswords({String format = 'csv'});

  /// Stream that emits whenever password data changes externally.
  /// Used for cross-screen synchronization (import, clear database, etc.).
  /// Subscribe to this stream to react to bulk data operations.
  Stream<void> get dataChanges;

  /// Bulk operations for performance optimization

  /// Saves multiple password entries in a single transaction.
  /// Emits dataChanges event after successful save.
  Future<Result<void>> saveBulkPasswords(List<PasswordEntry> entries);

  /// Deletes multiple password entries in a single transaction.
  /// Emits dataChanges event after successful deletion.
  Future<Result<void>> deleteBulkPasswords(List<String> ids);

  /// Clears all password entries from storage.
  /// Emits dataChanges event after successful clear.
  Future<Result<void>> clearAllPasswords();

  /// Disposes resources (closes stream controller).
  /// Called automatically by dependency injection.
  void dispose();
}
