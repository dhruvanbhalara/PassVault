import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/features/password_manager/data/datasources/password_local_data_source.dart';
import 'package:passvault/features/password_manager/data/models/password_entry_model.dart';
import 'package:passvault/features/password_manager/data/repositories/password_repository_impl.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

class MockPasswordLocalDataSource extends Mock
    implements PasswordLocalDataSource {}

void main() {
  late PasswordRepositoryImpl repository;
  late MockPasswordLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockPasswordLocalDataSource();
    repository = PasswordRepositoryImpl(mockDataSource);
  });

  final tDate = DateTime(2024, 1, 1);
  final tEntry = PasswordEntry(
    id: '1',
    appName: 'Test App',
    username: 'user',
    password: 'password',
    lastUpdated: tDate,
  );
  final tModel = PasswordEntryModel.fromEntity(tEntry);

  setUpAll(() {
    registerFallbackValue(tModel);
    registerFallbackValue(tEntry);
  });

  group('PasswordRepository', () {
    test(
      'getPasswords should return list of entities from datasource',
      () async {
        // Arrange
        when(
          () => mockDataSource.getPasswords(),
        ).thenAnswer((_) async => [tModel]);

        // Act
        final result = await repository.getPasswords();

        // Assert
        expect(result, contains(tEntry));
        verify(() => mockDataSource.getPasswords()).called(1);
      },
    );

    test('savePassword should call datasource savePassword', () async {
      // Arrange
      when(() => mockDataSource.savePassword(any())).thenAnswer((_) async {});

      // Act
      await repository.savePassword(tEntry);

      // Assert
      verify(
        () => mockDataSource.savePassword(
          any(
            that: isA<PasswordEntryModel>().having(
              (e) => e.id,
              'id',
              tEntry.id,
            ),
          ),
        ),
      ).called(1);
    });

    test('deletePassword should call datasource deletePassword', () async {
      // Arrange
      when(() => mockDataSource.deletePassword(any())).thenAnswer((_) async {});

      // Act
      await repository.deletePassword('1');

      // Assert
      verify(() => mockDataSource.deletePassword('1')).called(1);
    });
  });
}
