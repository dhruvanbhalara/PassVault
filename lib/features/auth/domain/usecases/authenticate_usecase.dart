import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class AuthenticateUseCase {
  final AuthRepository _repository;

  AuthenticateUseCase(this._repository);

  Future<Result<bool>> call() => _repository.authenticate();
}
