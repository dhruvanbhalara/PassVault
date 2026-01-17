import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/password_manager/domain/entities/import_result.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';

/// Use case for importing passwords from external sources.
///
/// Detects duplicates by comparing appName + username but does NOT
/// automatically skip or save them. Returns duplicates in ImportResult
/// for user resolution.
@lazySingleton
class ImportPasswordsUseCase {
  final PasswordRepository _repository;

  ImportPasswordsUseCase(this._repository);

  /// Import a list of password entries.
  ///
  /// [entries]: Password entries parsed from import file
  ///
  /// Returns [ImportResult] containing:
  /// - Successfully imported entries (saved to database)
  /// - Failed entries with error messages
  /// - Duplicate entries requiring user resolution
  Future<Result<ImportResult>> call(List<PasswordEntry> entries) {
    return _repository.importPasswords(entries);
  }
}
