import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
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

  group('AuthRepository', () {
    test('authenticate should delegate to BiometricService', () async {
      // Arrange
      when(
        () => mockBiometricService.authenticate(),
      ).thenAnswer((_) async => true);

      // Act
      final result = await repository.authenticate();

      // Assert
      expect(result, const Success(true));
      verify(() => mockBiometricService.authenticate()).called(1);
    });

    test('isBiometricAvailable should delegate to BiometricService', () async {
      // Arrange
      when(
        () => mockBiometricService.isBiometricAvailable,
      ).thenAnswer((_) async => true);

      // Act
      final result = await repository.isBiometricAvailable();

      // Assert
      expect(result, const Success(true));
      verify(() => mockBiometricService.isBiometricAvailable).called(1);
    });
  });
}
