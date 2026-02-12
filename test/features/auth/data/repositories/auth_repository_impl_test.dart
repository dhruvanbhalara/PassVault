import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/core/services/biometric_service.dart';
import 'package:passvault/features/auth/data/repositories/auth_repository_impl.dart';

class MockBiometricService extends Mock implements BiometricService {}

void main() {
  late AuthRepositoryImpl repository;
  late MockBiometricService mockBiometricService;

  setUp(() {
    mockBiometricService = MockBiometricService();
    repository = AuthRepositoryImpl(mockBiometricService);
  });

  group('$AuthRepositoryImpl', () {
    test('authenticate should delegate to BiometricService', () async {
      when(
        () => mockBiometricService.authenticate(),
      ).thenAnswer((_) async => true);
      final result = await repository.authenticate();
      expect(result, const Success(true));
      verify(() => mockBiometricService.authenticate()).called(1);
    });

    test('isBiometricAvailable should delegate to BiometricService', () async {
      when(
        () => mockBiometricService.isBiometricAvailable,
      ).thenAnswer((_) async => true);
      final result = await repository.isBiometricAvailable();
      expect(result, const Success(true));
      verify(() => mockBiometricService.isBiometricAvailable).called(1);
    });
  });
}
