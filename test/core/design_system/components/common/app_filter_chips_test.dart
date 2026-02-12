import 'package:flutter/services.dart';
import 'package:passvault/core/design_system/components/common/app_filter_chips.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  const labels = ['All', 'Recently Added', 'Most Used', 'Favorites'];
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await getL10n();
  });

  group('$AppFilterChips', () {
    testWidgets('renders all chip labels', (WidgetTester tester) async {
      await tester.pumpApp(
        AppFilterChips(labels: labels, selectedIndex: 0, onSelected: (_) {}),
      );

      for (final label in labels) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('renders single chip without overflow', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppFilterChips(
          labels: const ['All'],
          selectedIndex: 0,
          onSelected: (_) {},
        ),
      );

      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('calls onSelected with correct index when tapped', (
      WidgetTester tester,
    ) async {
      int? tappedIndex;

      await tester.pumpApp(
        AppFilterChips(
          labels: labels,
          selectedIndex: 0,
          onSelected: (index) => tappedIndex = index,
        ),
      );

      await tester.tap(find.text('Most Used'));
      await tester.pumpAndSettle();

      expect(tappedIndex, 2);
    });

    testWidgets('does not crash when onSelected is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const AppFilterChips(labels: labels, selectedIndex: 0),
      );

      // Should not throw
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
    });

    testWidgets('fires haptic feedback on selection', (
      WidgetTester tester,
    ) async {
      final hapticLog = <MethodCall>[];

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          if (methodCall.method == 'HapticFeedback.vibrate') {
            hapticLog.add(methodCall);
          }
          return null;
        },
      );

      await tester.pumpApp(
        AppFilterChips(labels: labels, selectedIndex: 0, onSelected: (_) {}),
      );

      await tester.tap(find.text('Recently Added'));
      await tester.pumpAndSettle();

      expect(
        hapticLog.any(
          (call) =>
              call.method == 'HapticFeedback.vibrate' &&
              call.arguments == 'HapticFeedbackType.selectionClick',
        ),
        isTrue,
      );

      // Clean up
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });

    testWidgets('has proper accessibility semantics for selected chip', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppFilterChips(labels: labels, selectedIndex: 0, onSelected: (_) {}),
      );

      final selectedSemantics = tester.getSemantics(find.text('All'));
      expect(
        selectedSemantics.label,
        contains(l10n.filterChipSemantics('All')),
      );
      expect(selectedSemantics.label, contains(l10n.selectedState));
    });

    testWidgets('has proper accessibility semantics for unselected chip', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppFilterChips(labels: labels, selectedIndex: 0, onSelected: (_) {}),
      );

      final unselectedSemantics = tester.getSemantics(
        find.text('Recently Added'),
      );
      expect(
        unselectedSemantics.label,
        contains(l10n.filterChipSemantics('Recently Added')),
      );
      expect(unselectedSemantics.label, isNot(contains(l10n.selectedState)));
    });

    testWidgets('renders correctly with dark theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppFilterChips(labels: labels, selectedIndex: 1, onSelected: (_) {}),
        theme: AppTheme.darkTheme,
      );

      for (final label in labels) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('renders correctly with AMOLED theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppFilterChips(labels: labels, selectedIndex: 2, onSelected: (_) {}),
        theme: AppTheme.amoledTheme,
      );

      for (final label in labels) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('handles many chips (scrollable)', (WidgetTester tester) async {
      final manyLabels = List.generate(20, (i) => 'Category $i');

      await tester.pumpApp(
        AppFilterChips(
          labels: manyLabels,
          selectedIndex: 0,
          onSelected: (_) {},
        ),
      );

      // First chips visible
      expect(find.text('Category 0'), findsOneWidget);

      // Later chips exist in widget tree but may be off-screen
      expect(find.text('Category 19'), findsOneWidget);
    });

    testWidgets('handles long label with ellipsis', (
      WidgetTester tester,
    ) async {
      const longLabel = 'This is a very long filter label that should truncate';

      await tester.pumpApp(
        AppFilterChips(
          labels: [longLabel, 'Short'],
          selectedIndex: 0,
          onSelected: (_) {},
        ),
      );

      // The text widget should exist
      expect(find.text(longLabel), findsOneWidget);
    });

    testWidgets('applies custom padding when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        AppFilterChips(
          labels: labels,
          selectedIndex: 0,
          onSelected: (_) {},
          padding: const EdgeInsets.all(24),
        ),
      );

      expect(find.byType(AppFilterChips), findsOneWidget);
    });
  });
}
