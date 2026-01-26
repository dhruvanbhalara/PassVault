import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/password_manager/data/models/password_entry_model.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

void main() {
  final tDate = DateTime(2024, 1, 1);
  final tEntry = PasswordEntry(
    id: '1',
    appName: 'Test App',
    username: 'user',
    password: 'password',
    lastUpdated: tDate,
  );
  final tModel = PasswordEntryModel(
    id: '1',
    appName: 'Test App',
    username: 'user',
    password: 'password',
    lastUpdated: tDate,
  );

  group('$PasswordEntryModel', () {
    test(
      'should be a subclass of PasswordEntry entity via conversion',
      () async {
        final result = tModel.toEntity();
        expect(result, isA<PasswordEntry>());
        expect(result.id, tModel.id);
        expect(result.appName, tModel.appName);
      },
    );

    test('fromEntity should return a valid model', () async {
      final result = PasswordEntryModel.fromEntity(tEntry);
      expect(result.id, tEntry.id);
      expect(result.appName, tEntry.appName);
      expect(result.username, tEntry.username);
      expect(result.password, tEntry.password);
      expect(result.lastUpdated, tEntry.lastUpdated);
    });

    test('toEntity should return a valid entity', () async {
      final result = tModel.toEntity();
      expect(result, tEntry);
    });
  });
}
