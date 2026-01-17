import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';

/// Use case for saving multiple passwords in a single bulk operation.
/// Maintains Clean Architecture by delegating to repository layer.
@injectable
class SaveBulkPasswordsUseCase {
  final PasswordRepository _repository;

  SaveBulkPasswordsUseCase(this._repository);

  /// Saves multiple password entries using bulk operation for performance.
  /// Returns Success(void) on success, Error(Failure) on failure.
  Future<Result<void>> call(List<PasswordEntry> entries) async {
    return await _repository.saveBulkPasswords(entries);
  }
}
