import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';
import 'package:passvault/features/auth/domain/usecases/check_biometrics_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late CheckBiometricsUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = CheckBiometricsUseCase(mockRepository);
  });

  test('should call repository.isBiometricAvailable', () async {
    // Arrange
    when(
      () => mockRepository.isBiometricAvailable(),
    ).thenAnswer((_) async => const Success(true));

    // Act
    final result = await useCase();

    // Assert
    expect(result, const Success(true));
    verify(() => mockRepository.isBiometricAvailable()).called(1);
  });
}
