import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';

@lazySingleton
class GetPasswordsUseCase {
  final PasswordRepository _repository;
  GetPasswordsUseCase(this._repository);
  Future<Result<List<PasswordEntry>>> call() => _repository.getPasswords();
}

@lazySingleton
class SavePasswordUseCase {
  final PasswordRepository _repository;
  SavePasswordUseCase(this._repository);
  Future<Result<void>> call(PasswordEntry entry) =>
      _repository.savePassword(entry);
}

@lazySingleton
class DeletePasswordUseCase {
  final PasswordRepository _repository;
  DeletePasswordUseCase(this._repository);
  Future<Result<void>> call(String id) => _repository.deletePassword(id);
}
