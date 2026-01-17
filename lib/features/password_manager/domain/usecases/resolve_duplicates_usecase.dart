import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';

/// Use case for resolving duplicate passwords based on user choices.
///
/// Applies user's resolution decisions:
/// - Keep Existing: No database changes
/// - Replace with New: Update existing entry with imported data
/// - Keep Both: Save imported entry with modified appName
@lazySingleton
class ResolveDuplicatesUseCase {
  final PasswordRepository _repository;

  ResolveDuplicatesUseCase(this._repository);

  /// Resolve duplicates based on user choices.
  ///
  /// [resolutions]: List of DuplicatePasswordEntry with user choices set
  ///
  /// Throws if any resolution has null userChoice.
  Future<Result<void>> call(List<DuplicatePasswordEntry> resolutions) {
    // Validate all resolutions have choices
    final unresolved = resolutions.where((r) => !r.isResolved).toList();
    if (unresolved.isNotEmpty) {
      return Future.value(
        Error(
          DataMigrationFailure('${unresolved.length} duplicates not resolved'),
        ),
      );
    }

    return _repository.resolveDuplicates(resolutions);
  }
}
