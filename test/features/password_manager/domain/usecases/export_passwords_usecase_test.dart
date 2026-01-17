import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/export_passwords_usecase.dart';

class MockPasswordRepository extends Mock implements PasswordRepository {}

void main() {
  late MockPasswordRepository mockRepository;
  late ExportPasswordsUseCase useCase;

  setUp(() {
    mockRepository = MockPasswordRepository();
    useCase = ExportPasswordsUseCase(mockRepository);
  });

  test('should call repository.exportPasswords with default format', () async {
    // Arrange
    when(
      () => mockRepository.exportPasswords(format: any(named: 'format')),
    ).thenAnswer((_) async => const Success('csv_data'));

    // Act
    final result = await useCase();

    // Assert
    expect(result, const Success('csv_data'));
    verify(() => mockRepository.exportPasswords(format: 'csv')).called(1);
  });

  test(
    'should call repository.exportPasswords with specified format',
    () async {
      // Arrange
      when(
        () => mockRepository.exportPasswords(format: any(named: 'format')),
      ).thenAnswer((_) async => const Success('json_data'));

      // Act
      final result = await useCase(format: 'json');

      // Assert
      expect(result, const Success('json_data'));
      verify(() => mockRepository.exportPasswords(format: 'json')).called(1);
    },
  );
}
