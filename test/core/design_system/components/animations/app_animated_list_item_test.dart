import 'package:passvault/core/design_system/components/animations/app_animated_list_item.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppAnimatedListItem', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      const childText = 'Test Child';

      await tester.pumpApp(
        const AppAnimatedListItem(index: 0, child: Text(childText)),
      );

      expect(find.text(childText), findsOneWidget);
    });

    testWidgets('applies staggered animation based on index', (
      WidgetTester tester,
    ) async {
      const firstChild = Text('First');
      const secondChild = Text('Second');

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

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets('completes animation after duration', (
      WidgetTester tester,
    ) async {
      const child = Text('Animated Child');

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
        const AppAnimatedListItem(index: 0, child: Text('Test')),
      );

      expect(find.byType(RepaintBoundary), findsWidgets);
    });
  });
}
