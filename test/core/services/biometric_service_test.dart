import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/services/biometric_service.dart';

class MockLocalAuthentication extends Mock implements LocalAuthentication {}

void main() {
  late BiometricService biometricService;
  late MockLocalAuthentication mockAuth;

  setUp(() {
    mockAuth = MockLocalAuthentication();
    biometricService = BiometricService(auth: mockAuth);
  });

  group('BiometricService', () {
    group('isBiometricAvailable', () {
      test(
        'should return true when hardware supports and can check biometrics',
        () async {
          when(() => mockAuth.canCheckBiometrics).thenAnswer((_) async => true);
          when(
            () => mockAuth.isDeviceSupported(),
          ).thenAnswer((_) async => true);

          final result = await biometricService.isBiometricAvailable;

          expect(result, true);
          verify(() => mockAuth.canCheckBiometrics).called(1);
        },
      );

      test('should return false when check throws exception', () async {
        when(() => mockAuth.canCheckBiometrics).thenThrow(Exception('Error'));

        final result = await biometricService.isBiometricAvailable;

        expect(result, false);
      });
    });

    group('authenticate', () {
      test('should return true when authentication succeeds', () async {
        when(
          () => mockAuth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
            persistAcrossBackgrounding: any(
              named: 'persistAcrossBackgrounding',
            ),
          ),
        ).thenAnswer((_) async => true);

        final result = await biometricService.authenticate();

        expect(result, true);
      });

      test('should return false when authentication fails', () async {
        when(
          () => mockAuth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
            persistAcrossBackgrounding: any(
              named: 'persistAcrossBackgrounding',
            ),
          ),
        ).thenAnswer((_) async => false);

        final result = await biometricService.authenticate();

        expect(result, false);
      });

      test('should return false when authenticate throws exception', () async {
        when(
          () => mockAuth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
            persistAcrossBackgrounding: any(
              named: 'persistAcrossBackgrounding',
            ),
          ),
        ).thenThrow(Exception('Auth error'));

        final result = await biometricService.authenticate();

        expect(result, false);
      });
    });
  });
}
