import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/core/services/biometric_service.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final BiometricService _biometricService;

  AuthRepositoryImpl(this._biometricService);

  @override
  Future<Result<bool>> authenticate() async {
    try {
      final success = await _biometricService.authenticate();
      return Success(success);
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> isBiometricAvailable() async {
    try {
      final available = await _biometricService.isBiometricAvailable;
      return Success(available);
    } catch (e) {
      return Error(AuthFailure(e.toString()));
    }
  }
}
