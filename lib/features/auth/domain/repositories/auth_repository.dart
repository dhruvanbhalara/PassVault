import 'package:passvault/core/error/result.dart';

abstract class AuthRepository {
  Future<Result<bool>> authenticate();
  Future<Result<bool>> isBiometricAvailable();
}
