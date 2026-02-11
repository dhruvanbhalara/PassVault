import 'package:passvault/core/utils/app_semantics.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('$AppSemantics', () {
    testWidgets('button wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppSemantics.button(
          label: 'Save',
          child: const ElevatedButton(onPressed: null, child: Text('Save')),
        ),
      );

      expect(find.text('Save'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('header wrapper renders child widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppSemantics.header(label: 'Security', child: const Text('Security')),
      );

      expect(find.text('Security'), findsOneWidget);
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
        AppSemantics.input(label: 'Password', child: const TextField()),
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
