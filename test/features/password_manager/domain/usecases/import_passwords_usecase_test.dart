import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/password_manager/domain/entities/import_result.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/import_passwords_usecase.dart';

class MockPasswordRepository extends Mock implements PasswordRepository {}

void main() {
  late MockPasswordRepository mockRepository;
  late ImportPasswordsUseCase useCase;

  setUp(() {
    mockRepository = MockPasswordRepository();
    useCase = ImportPasswordsUseCase(mockRepository);
  });

  final tEntry = PasswordEntry(
    id: '1',
    appName: 'Test App',
    username: 'user',
    password: 'password',
    lastUpdated: DateTime(2024, 1, 1),
  );

  final tImportResult = const ImportResult(
    totalRecords: 1,
    successfulImports: 1,
    failedImports: 0,
    duplicateEntries: [],
    errors: [],
  );

  group('$ImportPasswordsUseCase', () {
    test('should call repository.importPasswords and return result', () async {
      // Arrange
      when(
        () => mockRepository.importPasswords(any()),
      ).thenAnswer((_) async => Success(tImportResult));

      // Act
      final result = await useCase([tEntry]);

      // Assert
      expect(result, Success(tImportResult));
      verify(() => mockRepository.importPasswords([tEntry])).called(1);
    });
  });
}
