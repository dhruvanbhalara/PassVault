import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/password_manager/data/datasources/password_local_data_source.dart';
import 'package:passvault/features/password_manager/data/exporters/csv_exporter.dart';
import 'package:passvault/features/password_manager/data/models/password_entry_model.dart';
import 'package:passvault/features/password_manager/data/repositories/password_repository_impl.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

class MockPasswordLocalDataSource extends Mock
    implements PasswordLocalDataSource {}

class MockCsvExporter extends Mock implements CsvExporter {}

void main() {
  late PasswordRepositoryImpl repository;
  late MockPasswordLocalDataSource mockDataSource;
  late MockCsvExporter mockCsvExporter;

  setUp(() {
    mockDataSource = MockPasswordLocalDataSource();
    mockCsvExporter = MockCsvExporter();
    repository = PasswordRepositoryImpl(mockDataSource, mockCsvExporter);
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

  group('$PasswordRepositoryImpl', () {
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
        expect(result, Success([tEntry]));
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

    group('importPasswords', () {
      final tNewEntry = PasswordEntry(
        id: '2',
        appName: 'New App',
        username: 'newuser',
        password: 'newpassword',
        lastUpdated: tDate,
      );

      test('should import entries when no duplicates exist', () async {
        // Arrange
        when(() => mockDataSource.getPasswords()).thenAnswer((_) async => []);
        when(
          () => mockDataSource.savePasswordsBulk(any()),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.importPasswords([tNewEntry]);

        // Assert
        expect(result.isSuccess, true);
        final importResult = (result as Success).data;
        expect(importResult.successfulImports, 1);
        expect(importResult.duplicateEntries, isEmpty);
        verify(() => mockDataSource.savePasswordsBulk(any())).called(1);
      });

      test('should identify duplicates by appName and username', () async {
        // Arrange
        final duplicateEntry = PasswordEntry(
          id: 'duplicate-id',
          appName: tEntry.appName,
          username: tEntry.username,
          password: 'different-password',
          lastUpdated: tDate,
        );

        when(
          () => mockDataSource.getPasswords(),
        ).thenAnswer((_) async => [tModel]);

        // Act
        final result = await repository.importPasswords([duplicateEntry]);

        // Assert
        expect(result.isSuccess, true);
        final importResult = (result as Success).data;
        expect(importResult.successfulImports, 0);
        expect(importResult.duplicateEntries.length, 1);
        expect(importResult.duplicateEntries[0].existingEntry.id, tEntry.id);
        verifyNever(() => mockDataSource.savePassword(any()));
      });

      test('should return Error when getPasswords fails', () async {
        // Arrange
        when(
          () => mockDataSource.getPasswords(),
        ).thenThrow(Exception('DB Error'));

        // Act
        final result = await repository.importPasswords([tNewEntry]);

        // Assert
        expect(result.isFailure, true);
        verifyNever(() => mockDataSource.savePassword(any()));
      });

      test(
        'should return Error when savePassword fails during import',
        () async {
          // Arrange
          when(() => mockDataSource.getPasswords()).thenAnswer((_) async => []);
          when(
            () => mockDataSource.savePassword(any()),
          ).thenThrow(Exception('Save Error'));

          // Act
          final result = await repository.importPasswords([tNewEntry]);

          // Assert
          expect(result.isFailure, true);
        },
      );
    });

    group('resolveDuplicates', () {
      final tDuplicate = DuplicatePasswordEntry(
        existingEntry: tEntry,
        newEntry: tEntry.copyWith(id: 'new', password: 'new-password'),
        conflictReason: 'reason',
      );

      test('should replace existing when choice is replaceWithNew', () async {
        // Arrange
        final resolution = tDuplicate.copyWith(
          userChoice: DuplicateResolutionChoice.replaceWithNew,
        );
        when(() => mockDataSource.savePassword(any())).thenAnswer((_) async {});

        // Act
        final result = await repository.resolveDuplicates([resolution]);

        // Assert
        expect(result.isSuccess, true);
        verify(() => mockDataSource.savePassword(any())).called(1);
      });

      test(
        'should save as new when choice is keepBoth and append (imported)',
        () async {
          // Arrange
          final resolution = tDuplicate.copyWith(
            userChoice: DuplicateResolutionChoice.keepBoth,
          );
          when(
            () => mockDataSource.savePassword(any()),
          ).thenAnswer((_) async {});

          // Act
          await repository.resolveDuplicates([resolution]);

          // Assert
          verify(
            () => mockDataSource.savePassword(
              any(
                that: isA<PasswordEntryModel>().having(
                  (e) => e.appName,
                  'appName',
                  equals(tDuplicate.newEntry.appName),
                ),
              ),
            ),
          ).called(1);
        },
      );

      test('should do nothing when choice is keepExisting', () async {
        // Arrange
        final resolution = tDuplicate.copyWith(
          userChoice: DuplicateResolutionChoice.keepExisting,
        );

        // Act
        final result = await repository.resolveDuplicates([resolution]);

        // Assert
        expect(result.isSuccess, true);
        verifyNever(() => mockDataSource.savePassword(any()));
      });

      test('should return Error when save fails during resolution', () async {
        // Arrange
        final resolution = tDuplicate.copyWith(
          userChoice: DuplicateResolutionChoice.replaceWithNew,
        );
        when(
          () => mockDataSource.savePassword(any()),
        ).thenThrow(Exception('Save error'));

        // Act
        final result = await repository.resolveDuplicates([resolution]);

        // Assert
        expect(result.isFailure, true);
      });
    });

    group('exportPasswords', () {
      test('should return csv content on success', () async {
        // Arrange
        when(
          () => mockDataSource.getPasswords(),
        ).thenAnswer((_) async => [tModel]);
        when(() => mockCsvExporter.export(any())).thenReturn('csv,content');

        // Act
        final result = await repository.exportPasswords();

        // Assert
        expect(result.isSuccess, true);
        expect((result as Success).data, 'csv,content');
      });

      test('should return Error on data source failure', () async {
        // Arrange
        when(() => mockDataSource.getPasswords()).thenThrow(Exception('Error'));

        // Act
        final result = await repository.exportPasswords();

        // Assert
        expect(result.isFailure, true);
      });
    });
    group('dataChanges stream', () {
      test('should emit event when savePassword is successful', () async {
        // Arrange
        when(() => mockDataSource.savePassword(any())).thenAnswer((_) async {});

        // Act & Assert
        final future = expectLater(repository.dataChanges, emits(null));
        final result = await repository.savePassword(tEntry);
        await future;

        expect(result.isSuccess, true);
      });

      test('should emit event when deletePassword is successful', () async {
        // Arrange
        when(
          () => mockDataSource.deletePassword(any()),
        ).thenAnswer((_) async {});

        // Act & Assert
        final future = expectLater(repository.dataChanges, emits(null));
        final result = await repository.deletePassword('1');
        await future;

        expect(result.isSuccess, true);
      });
    });
  });
}
