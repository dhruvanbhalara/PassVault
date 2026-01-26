import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/auth/domain/repositories/auth_repository.dart';
import 'package:passvault/features/auth/domain/usecases/authenticate_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthenticateUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = AuthenticateUseCase(mockRepository);
  });

  group('$AuthenticateUseCase', () {
    test('should call repository.authenticate', () async {
      // Arrange
      when(
        () => mockRepository.authenticate(),
      ).thenAnswer((_) async => const Success(true));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Success(true));
      verify(() => mockRepository.authenticate()).called(1);
    });
  });
}
