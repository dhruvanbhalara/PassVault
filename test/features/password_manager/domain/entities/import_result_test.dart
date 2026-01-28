import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/password_manager/domain/entities/import_result.dart';

void main() {
  const tImportResult = ImportResult(
    totalRecords: 10,
    successfulImports: 5,
    failedImports: 2,
    duplicateEntries: [],
    errors: ['error 1', 'error 2'],
  );

  group('$ImportResult', () {
    test('duplicateCount should return length of duplicateEntries', () {
      expect(tImportResult.duplicateCount, 0);
    });

    test(
      'hasDuplicates should return true if duplicateEntries is not empty',
      () {
        expect(tImportResult.hasDuplicates, isFalse);
      },
    );

    test('isCompleteSuccess should return false if there are failures', () {
      expect(tImportResult.isCompleteSuccess, isFalse);
    });

    test('hasErrors should return true if errors list is not empty', () {
      expect(tImportResult.hasErrors, isTrue);
    });

    test('Equatable props should be correct', () {
      expect(tImportResult.props, [
        tImportResult.totalRecords,
        tImportResult.successfulImports,
        tImportResult.failedImports,
        tImportResult.duplicateEntries,
        tImportResult.errors,
      ]);
    });
  });
}
