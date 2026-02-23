import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
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

  group('$GetPasswordsUseCase', () {
    test('should call repository.getPasswords', () async {
      when(
        () => mockRepository.getPasswords(),
      ).thenAnswer((_) async => Success([tEntry]));

      final result = await getPasswordsUseCase();

      expect(result, Success([tEntry]));
      verify(() => mockRepository.getPasswords()).called(1);
    });
  });

  group('$SavePasswordUseCase', () {
    test('should call repository.savePassword', () async {
      when(
        () => mockRepository.savePassword(any()),
      ).thenAnswer((_) async => const Success(null));

      await savePasswordUseCase(tEntry);

      verify(() => mockRepository.savePassword(tEntry)).called(1);
    });
  });

  group('$DeletePasswordUseCase', () {
    test('should call repository.deletePassword', () async {
      when(
        () => mockRepository.deletePassword(any()),
      ).thenAnswer((_) async => const Success(null));

      await deletePasswordUseCase('1');

      verify(() => mockRepository.deletePassword('1')).called(1);
    });
  });
}
