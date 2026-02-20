import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/clear_all_passwords_usecase.dart';

class MockPasswordRepository extends Mock implements PasswordRepository {}

void main() {
  late ClearAllPasswordsUseCase useCase;
  late MockPasswordRepository mockRepository;

  setUp(() {
    mockRepository = MockPasswordRepository();
    useCase = ClearAllPasswordsUseCase(mockRepository);
  });

  group('$ClearAllPasswordsUseCase', () {
    test('should call repository.clearAllPasswords()', () async {
      when(
        () => mockRepository.clearAllPasswords(),
      ).thenAnswer((_) async => const Success(null));

      await useCase();

      verify(() => mockRepository.clearAllPasswords()).called(1);
    });

    test('should return Success when repository succeeds', () async {
      when(
        () => mockRepository.clearAllPasswords(),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase();

      expect(result, isA<Success<void>>());
    });

    test('should return Error when repository fails', () async {
      final failure = const DatabaseFailure('Clear failed');
      when(
        () => mockRepository.clearAllPasswords(),
      ).thenAnswer((_) async => Error(failure));

      final result = await useCase();

      expect(result, isA<Error<void>>());
      expect((result as Error).failure, failure);
    });
  });
}
