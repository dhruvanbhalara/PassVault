import 'package:injectable/injectable.dart';
import 'package:passvault/core/services/biometric_service.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final BiometricService _biometricService;

  AuthRepositoryImpl(this._biometricService);

  @override
  Future<bool> authenticate() => _biometricService.authenticate();

  @override
  Future<bool> isBiometricAvailable() => _biometricService.isBiometricAvailable;
}
