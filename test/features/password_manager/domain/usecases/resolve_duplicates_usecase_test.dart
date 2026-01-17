import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/resolve_duplicates_usecase.dart';

class MockPasswordRepository extends Mock implements PasswordRepository {}

void main() {
  late MockPasswordRepository mockRepository;
  late ResolveDuplicatesUseCase useCase;

  setUp(() {
    mockRepository = MockPasswordRepository();
    useCase = ResolveDuplicatesUseCase(mockRepository);
  });

  final tEntry = PasswordEntry(
    id: '1',
    appName: 'Test App',
    username: 'user',
    password: 'password',
    lastUpdated: DateTime(2024, 1, 1),
  );

  final tDuplicate = DuplicatePasswordEntry(
    existingEntry: tEntry,
    newEntry: tEntry,
    conflictReason: 'Test conflict',
    userChoice: DuplicateResolutionChoice.keepExisting,
  );

  final tDuplicateUnresolved = DuplicatePasswordEntry(
    existingEntry: tEntry,
    newEntry: tEntry,
    conflictReason: 'Test conflict',
    userChoice: null,
  );

  test(
    'should return ImportExportFailure when userChoice is missing',
    () async {
      // Act
      final result = await useCase([tDuplicateUnresolved]);

      // Assert
      expect(result, isA<Error<void>>());
      expect((result as Error).failure, isA<ImportExportFailure>());
    },
  );

  test('should call repository.resolveDuplicates when all resolved', () async {
    // Arrange
    when(
      () => mockRepository.resolveDuplicates(any()),
    ).thenAnswer((_) async => const Success(null));

    // Act
    final result = await useCase([tDuplicate]);

    // Assert
    expect(result, const Success<void>(null));
    verify(() => mockRepository.resolveDuplicates([tDuplicate])).called(1);
  });
}
