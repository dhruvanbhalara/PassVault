abstract class AuthRepository {
  Future<bool> authenticate();
  Future<bool> isBiometricAvailable();
}
