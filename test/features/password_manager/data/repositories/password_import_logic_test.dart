import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/password_manager/data/repositories/password_import_helper.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

void main() {
  group('PasswordImportHelper Logic Tests', () {
    final tDate = DateTime(2024);
    final existingEntries = [
      PasswordEntry(
        id: '1',
        appName: 'Google',
        username: 'user@gmail.com',
        password: 'old_password',
        lastUpdated: tDate,
      ),
      PasswordEntry(
        id: '2',
        appName: 'Github',
        username: 'git_user',
        password: 'git_password',
        lastUpdated: tDate,
      ),
    ];

    test('should identify duplicates correctly in mixed batch', () {
      final newEntries = [
        // Duplicate
        PasswordEntry(
          id: 'new_1',
          appName: 'Google',
          username: 'user@gmail.com',
          password: 'new_password',
          lastUpdated: tDate,
        ),
        // New
        PasswordEntry(
          id: 'new_2',
          appName: 'Slack',
          username: 'slack_user',
          password: 'slack_password',
          lastUpdated: tDate,
        ),
      ];

      final result = PasswordImportHelper.detectDuplicates(
        newEntries,
        existingEntries,
      );

      expect(result.totalRecords, 2);
      expect(result.duplicateCount, 1);
      expect(result.successfulImports, 1); // Only 1 to be directly imported
      expect(result.duplicateEntries[0].existingEntry.appName, 'Google');
      expect(result.duplicateEntries[0].newEntry.password, 'new_password');
    });

    test(
      'should handle sequential re-import of same file as all duplicates',
      () {
        final result = PasswordImportHelper.detectDuplicates(
          existingEntries,
          existingEntries,
        );

        expect(result.totalRecords, 2);
        expect(result.duplicateCount, 2);
        expect(result.successfulImports, 0);
      },
    );

    test('getUniqueEntriesToImport should return only non-duplicates', () {
      final newEntries = [
        PasswordEntry(
          id: 'd',
          appName: 'Google',
          username: 'user@gmail.com',
          password: 'p',
          lastUpdated: tDate,
        ),
        PasswordEntry(
          id: 'n',
          appName: 'New',
          username: 'new',
          password: 'p',
          lastUpdated: tDate,
        ),
      ];

      final result = PasswordImportHelper.detectDuplicates(
        newEntries,
        existingEntries,
      );
      final toImport = PasswordImportHelper.getUniqueEntriesToImport(
        result,
        newEntries,
      );

      expect(toImport.length, 1);
      expect(toImport[0].appName, 'New');
    });
  });
}
