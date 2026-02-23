import 'package:passvault/core/design_system/components/layout/app_card.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  const cardContent = 'Card Content';
  const clickableContent = 'Clickable';
  const tapContent = 'Tap Me';

  group('$AppCard', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpApp(const AppCard(child: Text(cardContent)));

      expect(find.text(cardContent), findsOneWidget);
    });

    testWidgets('renders inkwell when onTap provided', (tester) async {
      await tester.pumpApp(
        AppCard(onTap: () {}, child: const Text(clickableContent)),
      );

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('calls onTap when clicked', (tester) async {
      bool tapped = false;
      await tester.pumpApp(
        AppCard(onTap: () => tapped = true, child: const Text(tapContent)),
      );

      await tester.tap(find.byType(AppCard));

      expect(tapped, true);
    });
  });
}
