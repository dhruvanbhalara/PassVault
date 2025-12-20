import 'package:injectable/injectable.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class CheckBiometricsUseCase {
  final AuthRepository _repository;

  CheckBiometricsUseCase(this._repository);

  Future<bool> call() => _repository.isBiometricAvailable();
}
