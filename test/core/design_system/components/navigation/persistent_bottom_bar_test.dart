import 'package:passvault/core/design_system/components/navigation/persistent_bottom_bar.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group(r'$PersistentBottomBar', () {
    late ScrollController scrollController;

    setUp(() {
      scrollController = ScrollController();
    });

    tearDown(() {
      scrollController.dispose();
    });

    testWidgets('renders child', (tester) async {
      await tester.pumpApp(const PersistentBottomBar(child: Text('Child')));

      expect(find.text('Child'), findsOneWidget);
    });

    testWidgets(
      'hides on scroll down (forward) and shows on scroll up (reverse)',
      (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: ListView.builder(
              controller: scrollController,
              itemCount: 100,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
            bottomNavigationBar: PersistentBottomBar(
              scrollController: scrollController,
              child: const Text('Bottom Bar'),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Bottom Bar'), findsOneWidget);

        // Scroll Down (Forward) -> Should hide
        // Dragging up moves content down? No, dragging up moves viewport down (scroll offset increases).
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pump(); // Start animation
        await tester.pump(
          const Duration(milliseconds: 150),
        ); // Advance animation

        // Verify it's effectively hidden or sliding down (offsetY > 0)
        // Since it's a SlideTransition, we can check the transform?
        // Or just check that it's offscreen?
        // SlideTransition with offset (0,1) moves it down by 100% of its height.
        // Render object check is robust.
        final slideTransition = tester.widget<SlideTransition>(
          find.descendant(
            of: find.byType(PersistentBottomBar),
            matching: find.byType(SlideTransition),
          ),
        );
        // If hiding, value should be increasing towards 1.0 (Offset(0,1))
        // Animation controller value:
        // forward() -> towards 1.0.
        expect(slideTransition.position.value.dy, greaterThan(0.0));

        await tester.pumpAndSettle();
        // Fully hidden
        expect(slideTransition.position.value.dy, equals(1.0));

        // Scroll Up (Reverse) -> Should show
        await tester.drag(find.byType(ListView), const Offset(0, 500));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 150));

        expect(slideTransition.position.value.dy, lessThan(1.0));

        await tester.pumpAndSettle();
        expect(slideTransition.position.value.dy, equals(0.0));
      },
    );
  });
}
