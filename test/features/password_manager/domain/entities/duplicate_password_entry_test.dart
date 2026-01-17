import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

void main() {
  final tEntry1 = PasswordEntry(
    id: '1',
    appName: 'App 1',
    username: 'user1',
    password: 'pass1',
    lastUpdated: DateTime(2024),
  );

  final tEntry2 = PasswordEntry(
    id: '2',
    appName: 'App 2',
    username: 'user2',
    password: 'pass2',
    lastUpdated: DateTime(2024),
  );

  final tDuplicate = DuplicatePasswordEntry(
    existingEntry: tEntry1,
    newEntry: tEntry2,
    conflictReason: 'reason',
  );

  group('DuplicatePasswordEntry', () {
    test('isResolved should return false when userChoice is null', () {
      expect(tDuplicate.isResolved, isFalse);
    });

    test('isResolved should return true when userChoice is set', () {
      final resolved = tDuplicate.copyWith(
        userChoice: DuplicateResolutionChoice.keepExisting,
      );
      expect(resolved.isResolved, isTrue);
    });

    test('withChoice should return a new instance with updated choice', () {
      final updated = tDuplicate.withChoice(DuplicateResolutionChoice.keepBoth);
      expect(updated.userChoice, DuplicateResolutionChoice.keepBoth);
      expect(updated.existingEntry, tDuplicate.existingEntry);
      expect(updated.newEntry, tDuplicate.newEntry);
    });

    test('copyWith should update specified fields', () {
      final updated = tDuplicate.copyWith(conflictReason: 'new reason');
      expect(updated.conflictReason, 'new reason');
      expect(updated.existingEntry, tDuplicate.existingEntry);
    });

    test('Equatable props should be correct', () {
      expect(tDuplicate.props, [
        tDuplicate.existingEntry,
        tDuplicate.newEntry,
        tDuplicate.conflictReason,
        tDuplicate.userChoice,
      ]);
    });
  });
}
