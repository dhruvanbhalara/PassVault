import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/features/password_manager/data/datasources/password_local_data_source.dart';
import 'package:passvault/features/password_manager/data/models/password_entry_model.dart';

class MockBox extends Mock implements Box<dynamic> {}

void main() {
  late PasswordLocalDataSourceImpl dataSource;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    when(() => mockBox.name).thenReturn('passwords');
    dataSource = PasswordLocalDataSourceImpl(mockBox);
  });

  final tDate = DateTime(2024, 1, 1);
  final tModel = PasswordEntryModel(
    id: '1',
    appName: 'Test App',
    username: 'user',
    password: 'password',
    lastUpdated: tDate,
  );

  group('PasswordLocalDataSource', () {
    test('getPasswords should return list of models from box', () async {
      // Arrange
      when(() => mockBox.values).thenReturn([tModel]);

      // Act
      final result = await dataSource.getPasswords();

      // Assert
      expect(result, contains(tModel));
      verify(() => mockBox.values).called(1);
    });

    test('savePassword should put entry into box', () async {
      // Arrange
      when(() => mockBox.put(any(), any())).thenAnswer((_) async {});

      // Act
      await dataSource.savePassword(tModel);

      // Assert
      verify(() => mockBox.put('1', tModel)).called(1);
    });

    test('deletePassword should remove entry from box', () async {
      // Arrange
      when(() => mockBox.delete(any())).thenAnswer((_) async {});

      // Act
      await dataSource.deletePassword('1');

      // Assert
      verify(() => mockBox.delete('1')).called(1);
    });

    group('Bulk Operations', () {
      test(
        'savePasswordsBulk should call box.putAll with correct map',
        () async {
          // Arrange
          final entries = [
            PasswordEntryModel(
              id: '1',
              appName: 'App 1',
              username: 'user1',
              password: 'pass1',
              lastUpdated: tDate,
            ),
            PasswordEntryModel(
              id: '2',
              appName: 'App 2',
              username: 'user2',
              password: 'pass2',
              lastUpdated: tDate,
            ),
          ];
          when(() => mockBox.putAll(any())).thenAnswer((_) async {});

          // Act
          await dataSource.savePasswordsBulk(entries);

          // Assert
          final captured =
              verify(() => mockBox.putAll(captureAny())).captured.single as Map;
          expect(captured.length, 2);
          expect(captured['1'], entries[0]);
          expect(captured['2'], entries[1]);
        },
      );

      test('savePasswordsBulk should handle empty list', () async {
        // Arrange
        when(() => mockBox.putAll(any())).thenAnswer((_) async {});

        // Act
        await dataSource.savePasswordsBulk([]);

        // Assert
        final captured =
            verify(() => mockBox.putAll(captureAny())).captured.single as Map;
        expect(captured.isEmpty, true);
      });

      test(
        'deletePasswordsBulk should call box.deleteAll with correct ids',
        () async {
          // Arrange
          final ids = ['1', '2', '3'];
          when(() => mockBox.deleteAll(any())).thenAnswer((_) async {});

          // Act
          await dataSource.deletePasswordsBulk(ids);

          // Assert
          verify(() => mockBox.deleteAll(ids)).called(1);
        },
      );

      test('deletePasswordsBulk should handle empty list', () async {
        // Arrange
        when(() => mockBox.deleteAll(any())).thenAnswer((_) async {});

        // Act
        await dataSource.deletePasswordsBulk([]);

        // Assert
        verify(() => mockBox.deleteAll([])).called(1);
      });

      test('clearAllPasswords should call box.clear', () async {
        // Arrange
        when(() => mockBox.length).thenReturn(10);
        when(() => mockBox.clear()).thenAnswer((_) async => 10);

        // Act
        await dataSource.clearAllPasswords();

        // Assert
        verify(() => mockBox.length).called(1);
        verify(() => mockBox.clear()).called(1);
      });

      test(
        'clearAllPasswords should log entry count before clearing',
        () async {
          // Arrange
          when(() => mockBox.length).thenReturn(242);
          when(() => mockBox.clear()).thenAnswer((_) async => 242);

          // Act
          await dataSource.clearAllPasswords();

          // Assert
          verify(() => mockBox.length).called(1);
          verify(() => mockBox.clear()).called(1);
        },
      );
    });
  });
}
