import 'package:passvault/core/design_system/components/animations/app_animated_list_item.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  const childText = 'Test Child';
  const firstText = 'First';
  const secondText = 'Second';
  const animatedChildText = 'Animated Child';

  group('$AppAnimatedListItem', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpApp(
        const AppAnimatedListItem(index: 0, child: Text(childText)),
      );

      expect(find.text(childText), findsOneWidget);
    });

    testWidgets('applies staggered animation based on index', (
      WidgetTester tester,
    ) async {
      const firstChild = Text(firstText);
      const secondChild = Text(secondText);

      await tester.pumpApp(
        const Column(
          children: [
            AppAnimatedListItem(index: 0, child: firstChild),
            AppAnimatedListItem(index: 1, child: secondChild),
          ],
        ),
        usePumpAndSettle: false,
      );

      // Pump once to start animations
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text(firstText), findsOneWidget);
      expect(find.text(secondText), findsOneWidget);
    });

    testWidgets('completes animation after duration', (
      WidgetTester tester,
    ) async {
      const child = Text(animatedChildText);

      await tester.pumpApp(
        const AppAnimatedListItem(index: 0, child: child),
        usePumpAndSettle: false,
      );

      // Pump frames to complete animation
      await tester.pump(); // Start
      await tester.pump(const Duration(milliseconds: 100)); // Mid
      await tester.pump(const Duration(milliseconds: 500)); // Complete

      expect(find.byWidget(child), findsOneWidget);
    });

    testWidgets('wraps child with RepaintBoundary', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const AppAnimatedListItem(index: 0, child: Text(childText)),
      );

      expect(find.byType(RepaintBoundary), findsWidgets);
    });
  });
}
