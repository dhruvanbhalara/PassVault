import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/presentation/widgets/duplicate_card.dart';

import '../../../../fixtures/password_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

class MockOnChoiceChanged extends Mock {
  void call(DuplicateResolutionChoice choice);
}

void main() {
  late DuplicatePasswordEntry testDuplicate;
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await getL10n();
  });

  setUp(() {
    testDuplicate = DuplicatePasswordEntry(
      existingEntry: PasswordFixtures.google,
      newEntry: PasswordFixtures.google.copyWith(
        id: 'new_id',
        password: 'new_password',
      ),
      conflictReason: 'Username already exists',
    );
  });

  group('$DuplicateCard', () {
    testWidgets('renders all duplicate information', (tester) async {
      final onChoiceChanged = MockOnChoiceChanged();
      await tester.pumpApp(
        DuplicateCard(
          duplicate: testDuplicate,
          onChoiceChanged: onChoiceChanged.call,
        ),
      );

      expect(find.text(testDuplicate.existingEntry.appName), findsOneWidget);
      expect(
        find.textContaining(testDuplicate.existingEntry.username),
        findsOneWidget,
      );
      expect(find.text('Username already exists'), findsOneWidget);
    });

    testWidgets('calls onChoiceChanged when a resolution is selected', (
      tester,
    ) async {
      final onChoiceChanged = MockOnChoiceChanged();
      await tester.pumpApp(
        DuplicateCard(
          duplicate: testDuplicate,
          onChoiceChanged: onChoiceChanged.call,
        ),
      );

      await tester.tap(find.text(l10n.keepExistingTitle));
      await tester.pumpAndSettle();

      verify(
        () => onChoiceChanged.call(DuplicateResolutionChoice.keepExisting),
      ).called(1);
    });
  });
}
