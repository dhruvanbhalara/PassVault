import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/services/database_service.dart';

class MockBox extends Mock implements Box<dynamic> {}

void main() {
  late DatabaseService databaseService;
  late MockBox mockSettingsBox;

  setUp(() {
    mockSettingsBox = MockBox();
    databaseService = DatabaseService(mockSettingsBox);
  });

  group('DatabaseService', () {
    const boxName = 'settings';
    const key = 'test_key';
    const value = 'test_value';

    test('write should call put on the box', () async {
      when(() => mockSettingsBox.put(any(), any())).thenAnswer((_) async => {});

      await databaseService.write(boxName, key, value);

      verify(() => mockSettingsBox.put(key, value)).called(1);
    });

    test('read should call get on the box', () {
      when(
        () => mockSettingsBox.get(
          any(),
          defaultValue: any(named: 'defaultValue'),
        ),
      ).thenReturn(value);

      final result = databaseService.read(boxName, key);

      expect(result, value);
      verify(() => mockSettingsBox.get(key, defaultValue: null)).called(1);
    });

    test('delete should call delete on the box', () async {
      when(() => mockSettingsBox.delete(any())).thenAnswer((_) async => {});

      await databaseService.delete(boxName, key);

      verify(() => mockSettingsBox.delete(key)).called(1);
    });

    test('clear should call clear on the box', () async {
      when(() => mockSettingsBox.clear()).thenAnswer((_) async => 0);

      await databaseService.clear(boxName);

      verify(() => mockSettingsBox.clear()).called(1);
    });
  });
}
