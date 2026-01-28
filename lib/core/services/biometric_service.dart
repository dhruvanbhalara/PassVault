import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:passvault/core/utils/app_logger.dart';

@lazySingleton
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> get isBiometricAvailable async {
    try {
      final canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      AppLogger.info(
        'Biometric check: available=$canAuthenticate '
        '(hardware=$canAuthenticateWithBiometrics)',
        tag: 'BiometricService',
      );
      return canAuthenticate;
    } catch (e, s) {
      AppLogger.error(
        'Failed to check biometric availability',
        error: e,
        stackTrace: s,
        tag: 'BiometricService',
      );
      return false;
    }
  }

  Future<bool> authenticate({
    String localizedReason = 'Please authenticate to unlock PassVault',
  }) async {
    try {
      AppLogger.info(
        'Requesting biometric authentication',
        tag: 'BiometricService',
      );
      final result = await _auth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      AppLogger.info('Authentication result: $result', tag: 'BiometricService');
      return result;
    } catch (e, s) {
      AppLogger.error(
        'Biometric authentication error',
        error: e,
        stackTrace: s,
        tag: 'BiometricService',
      );
      return false;
    }
  }
}
