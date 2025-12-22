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
  });
}
