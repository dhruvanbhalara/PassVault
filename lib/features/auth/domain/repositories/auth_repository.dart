import 'package:passvault/core/error/error.dart';

abstract class AuthRepository {
  Future<Result<bool>> authenticate();
  Future<Result<bool>> isBiometricAvailable();
}
