import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/password_usecases.dart';

class MockPasswordRepository extends Mock implements PasswordRepository {}

void main() {
  late MockPasswordRepository mockRepository;
  late GetPasswordsUseCase getPasswordsUseCase;
  late SavePasswordUseCase savePasswordUseCase;
  late DeletePasswordUseCase deletePasswordUseCase;

  setUp(() {
    mockRepository = MockPasswordRepository();
    getPasswordsUseCase = GetPasswordsUseCase(mockRepository);
    savePasswordUseCase = SavePasswordUseCase(mockRepository);
    deletePasswordUseCase = DeletePasswordUseCase(mockRepository);
  });

  final tEntry = PasswordEntry(
    id: '1',
    appName: 'Test App',
    username: 'user',
    password: 'password',
    lastUpdated: DateTime(2024, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(tEntry);
  });

  group('PasswordUseCases', () {
    test('GetPasswordsUseCase should call repository.getPasswords', () async {
      // Arrange
      when(
        () => mockRepository.getPasswords(),
      ).thenAnswer((_) async => [tEntry]);

      // Act
      final result = await getPasswordsUseCase();

      // Assert
      expect(result, [tEntry]);
      verify(() => mockRepository.getPasswords()).called(1);
    });

    test('SavePasswordUseCase should call repository.savePassword', () async {
      // Arrange
      when(() => mockRepository.savePassword(any())).thenAnswer((_) async {});

      // Act
      await savePasswordUseCase(tEntry);

      // Assert
      verify(() => mockRepository.savePassword(tEntry)).called(1);
    });

    test(
      'DeletePasswordUseCase should call repository.deletePassword',
      () async {
        // Arrange
        when(
          () => mockRepository.deletePassword(any()),
        ).thenAnswer((_) async {});

        // Act
        await deletePasswordUseCase('1');

        // Assert
        verify(() => mockRepository.deletePassword('1')).called(1);
      },
    );
  });
}
