import 'package:passvault/features/home/presentation/widgets/password_list_tile.dart';

import '../../../../fixtures/password_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

class MockCallback extends Mock {
  void call();
}

void main() {
  late PasswordEntry testEntry;

  setUp(() {
    testEntry = PasswordFixtures.google;
  });

  group('$PasswordListTile', () {
    testWidgets('renders entry details', (tester) async {
      await tester.pumpApp(
        PasswordListTile(entry: testEntry, onTap: () {}, onDismissed: () {}),
      );

      expect(find.text(testEntry.appName), findsOneWidget);
      expect(find.text(testEntry.username), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      final onTap = MockCallback();
      await tester.pumpApp(
        PasswordListTile(
          entry: testEntry,
          onTap: onTap.call,
          onDismissed: () {},
        ),
      );

      await tester.tap(find.byType(ListTile));

      verify(() => onTap()).called(1);
    });
  });
}
