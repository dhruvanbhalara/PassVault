import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';

/// Use case for clearing all passwords from the database.
/// Delegates to repository's bulk operation for performance.
@injectable
class ClearAllPasswordsUseCase {
  final PasswordRepository _repository;

  ClearAllPasswordsUseCase(this._repository);

  Future<Result<void>> call() async {
    return await _repository.clearAllPasswords();
  }
}
