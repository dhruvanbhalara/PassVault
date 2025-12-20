import 'package:injectable/injectable.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class AuthenticateUseCase {
  final AuthRepository _repository;

  AuthenticateUseCase(this._repository);

  Future<bool> call() => _repository.authenticate();
}
