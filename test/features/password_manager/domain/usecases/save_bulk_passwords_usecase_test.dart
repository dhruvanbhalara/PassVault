import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/save_bulk_passwords_usecase.dart';

class MockPasswordRepository extends Mock implements PasswordRepository {}

void main() {
  late SaveBulkPasswordsUseCase useCase;
  late MockPasswordRepository mockRepository;

  setUp(() {
    mockRepository = MockPasswordRepository();
    useCase = SaveBulkPasswordsUseCase(mockRepository);
  });

  group('SaveBulkPasswordsUseCase', () {
    final tDate = DateTime(2024, 1, 1);
    final testEntries = <PasswordEntry>[
      PasswordEntry(
        id: '1',
        appName: 'Test App 1',
        username: 'user1',
        password: 'pass1',
        lastUpdated: tDate,
      ),
      PasswordEntry(
        id: '2',
        appName: 'Test App 2',
        username: 'user2',
        password: 'pass2',
        lastUpdated: tDate,
      ),
    ];

    test(
      'should call repository.saveBulkPasswords with correct entries',
      () async {
        // Arrange
        when(
          () => mockRepository.saveBulkPasswords(any()),
        ).thenAnswer((_) async => const Success(null));

        // Act
        await useCase(testEntries);

        // Assert
        verify(() => mockRepository.saveBulkPasswords(testEntries)).called(1);
      },
    );

    test('should return Success when repository succeeds', () async {
      // Arrange
      when(
        () => mockRepository.saveBulkPasswords(any()),
      ).thenAnswer((_) async => const Success(null));

      // Act
      final result = await useCase(testEntries);

      // Assert
      expect(result, isA<Success<void>>());
    });

    test('should return Error when repository fails', () async {
      // Arrange
      final failure = DatabaseFailure('Save failed');
      when(
        () => mockRepository.saveBulkPasswords(any()),
      ).thenAnswer((_) async => Error(failure));

      // Act
      final result = await useCase(testEntries);

      // Assert
      expect(result, isA<Error<void>>());
      expect((result as Error).failure, failure);
    });

    test('should handle empty list', () async {
      // Arrange
      when(
        () => mockRepository.saveBulkPasswords(any()),
      ).thenAnswer((_) async => const Success(null));

      // Act
      final result = await useCase(<PasswordEntry>[]);

      // Assert
      verify(
        () => mockRepository.saveBulkPasswords(<PasswordEntry>[]),
      ).called(1);
      expect(result, isA<Success<void>>());
    });

    test('should handle large list of entries', () async {
      // Arrange
      final largeList = List<PasswordEntry>.generate(
        1000,
        (i) => PasswordEntry(
          id: '$i',
          appName: 'App $i',
          username: 'user$i',
          password: 'pass$i',
          lastUpdated: tDate,
        ),
      );
      when(
        () => mockRepository.saveBulkPasswords(any()),
      ).thenAnswer((_) async => const Success(null));

      // Act
      final result = await useCase(largeList);

      // Assert
      verify(() => mockRepository.saveBulkPasswords(largeList)).called(1);
      expect(result, isA<Success<void>>());
    });
  });
}
