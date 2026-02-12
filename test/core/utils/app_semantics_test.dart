import 'package:passvault/core/utils/app_semantics.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('$AppSemantics', () {
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await getL10n();
    });

    testWidgets('button wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppSemantics.button(
          label: l10n.save,
          child: ElevatedButton(onPressed: null, child: Text(l10n.save)),
        ),
      );

      expect(find.text(l10n.save), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('header wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppSemantics.header(label: l10n.security, child: Text(l10n.security)),
      );

      expect(find.text(l10n.security), findsOneWidget);
    });

    testWidgets('listItem wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppSemantics.listItem(
          label: 'Password entry',
          child: const ListTile(title: Text('example.com')),
        ),
      );

      expect(find.text('example.com'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('input wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppSemantics.input(label: l10n.passwordLabel, child: const TextField()),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('loading wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppSemantics.loading(child: const CircularProgressIndicator()),
        usePumpAndSettle: false,
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('image wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppSemantics.image(label: 'Icon', child: const Icon(Icons.security)),
      );

      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('link wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppSemantics.link(label: 'Privacy', child: const Text('Privacy')),
      );

      expect(find.text('Privacy'), findsOneWidget);
    });

    testWidgets('announce does not throw exception', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => AppSemantics.announce(context, 'Test message'),
              child: const Text('Announce'),
            );
          },
        ),
      );

      await tester.tap(find.text('Announce'));
      await tester.pumpAndSettle();
      expect(find.text('Announce'), findsOneWidget);
    });
  });
}
