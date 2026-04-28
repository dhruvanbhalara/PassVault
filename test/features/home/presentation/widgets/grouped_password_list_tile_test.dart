import 'package:passvault/features/home/domain/entities/grouped_home_entry.dart';
import 'package:passvault/features/home/presentation/widgets/grouped_password_list_tile.dart';

import '../../../../fixtures/password_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

class MockCallback extends Mock {
  void call();
}

void main() {
  late GroupedHomeEntry multiEntryGroup;
  late GroupedHomeEntry singleEntryGroup;
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await getL10n();
  });

  setUp(() {
    multiEntryGroup = GroupedHomeEntry(
      canonicalKey: 'google.com',
      displayName: 'google.com',
      members: [
        PasswordFixtures.google,
        PasswordFixtures.google.copyWith(id: 'google-2'),
      ],
    );
    singleEntryGroup = GroupedHomeEntry(
      canonicalKey: 'facebook.com',
      displayName: 'facebook.com',
      members: [PasswordFixtures.facebook],
    );
  });

  group('$GroupedPasswordListTile', () {
    testWidgets(
      'shows count badge only when account count is greater than one',
      (tester) async {
        await tester.pumpApp(
          GroupedPasswordListTile(group: multiEntryGroup, onTap: () {}),
        );

        expect(find.text(l10n.groupedCredentialCount(2)), findsOneWidget);

        await tester.pumpApp(
          GroupedPasswordListTile(group: singleEntryGroup, onTap: () {}),
        );

        expect(find.text(l10n.groupedCredentialCount(1)), findsNothing);
        expect(
          find.text(singleEntryGroup.members.first.username),
          findsNothing,
        );
      },
    );

    testWidgets('calls onTap when tapped', (tester) async {
      final onTap = MockCallback();

      await tester.pumpApp(
        GroupedPasswordListTile(group: multiEntryGroup, onTap: onTap.call),
      );

      await tester.tap(
        find.byKey(
          Key('grouped_password_tile_${multiEntryGroup.canonicalKey}'),
        ),
      );
      await tester.pumpAndSettle();

      verify(() => onTap()).called(1);
    });
  });
}
