import 'package:passvault/core/design_system/components/layout/app_card.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppCard', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpApp(const AppCard(child: Text('Card Content')));

      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('renders inkwell when onTap provided', (tester) async {
      await tester.pumpApp(
        AppCard(onTap: () {}, child: const Text('Clickable')),
      );

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('calls onTap when clicked', (tester) async {
      bool tapped = false;
      await tester.pumpApp(
        AppCard(onTap: () => tapped = true, child: const Text('Tap Me')),
      );

      await tester.tap(find.byType(AppCard));

      expect(tapped, true);
    });
  });
}
