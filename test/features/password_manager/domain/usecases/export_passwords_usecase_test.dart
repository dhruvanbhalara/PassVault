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

  group('$ExportPasswordsUseCase', () {
    test(
      'should call repository.exportPasswords with default format',
      () async {
        when(
          () => mockRepository.exportPasswords(format: any(named: 'format')),
        ).thenAnswer((_) async => const Success('csv_data'));

        final result = await useCase();

        expect(result, const Success('csv_data'));
        verify(() => mockRepository.exportPasswords(format: 'csv')).called(1);
      },
    );

    test(
      'should call repository.exportPasswords with specified format',
      () async {
        when(
          () => mockRepository.exportPasswords(format: any(named: 'format')),
        ).thenAnswer((_) async => const Success('json_data'));

        final result = await useCase(format: 'json');

        expect(result, const Success('json_data'));
        verify(() => mockRepository.exportPasswords(format: 'json')).called(1);
      },
    );
  });
}
