import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';

@lazySingleton
class GetPasswordUseCase {
  final PasswordRepository _repository;

  GetPasswordUseCase(this._repository);

  Future<Result<PasswordEntry?>> call(String id) {
    return _repository.getPassword(id);
  }
}
