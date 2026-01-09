import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class CheckBiometricsUseCase {
  final AuthRepository _repository;

  CheckBiometricsUseCase(this._repository);

  Future<Result<bool>> call() => _repository.isBiometricAvailable();
}
