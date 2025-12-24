import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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

  test('should call repository.authenticate', () async {
    // Arrange
    when(() => mockRepository.authenticate()).thenAnswer((_) async => true);

    // Act
    final result = await useCase();

    // Assert
    expect(result, true);
    verify(() => mockRepository.authenticate()).called(1);
  });
}
