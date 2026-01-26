import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';

void main() {
  group('$DuplicateResolutionChoice', () {
    test('contains exact number of enum values', () {
      expect(DuplicateResolutionChoice.values.length, 3);
    });

    test('validates enum values', () {
      expect(
        DuplicateResolutionChoice.values,
        contains(DuplicateResolutionChoice.keepExisting),
      );
      expect(
        DuplicateResolutionChoice.values,
        contains(DuplicateResolutionChoice.replaceWithNew),
      );
      expect(
        DuplicateResolutionChoice.values,
        contains(DuplicateResolutionChoice.keepBoth),
      );
    });
  });
}
