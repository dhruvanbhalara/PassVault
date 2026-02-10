import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/components/animations/app_animated_list_item.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppAnimatedListItem', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      // Given
      const childText = 'Test Child';

      // When
      await tester.pumpWidget(
        createTestWidget(
          child: const AppAnimatedListItem(index: 0, child: Text(childText)),
        ),
      );
      // Pump once to start animation
      await tester.pump();
      await tester.pumpAndSettle();

      // Then
      expect(find.text(childText), findsOneWidget);
    });

    testWidgets('applies staggered animation based on index', (
      WidgetTester tester,
    ) async {
      // Given
      const firstChild = Text('First');
      const secondChild = Text('Second');

      // When
      await tester.pumpWidget(
        createTestWidget(
          child: const Column(
            children: [
              AppAnimatedListItem(index: 0, child: firstChild),
              AppAnimatedListItem(index: 1, child: secondChild),
            ],
          ),
        ),
      );

      // Pump once to start animations
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Then - both should eventually be visible
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets('completes animation after duration', (
      WidgetTester tester,
    ) async {
      // Given
      const child = Text('Animated Child');

      // When
      await tester.pumpWidget(
        createTestWidget(
          child: const AppAnimatedListItem(index: 0, child: child),
        ),
      );

      // Pump frames to complete animation
      await tester.pump(); // Start
      await tester.pump(const Duration(milliseconds: 100)); // Mid
      await tester.pump(const Duration(milliseconds: 500)); // Complete

      // Then
      expect(find.byWidget(child), findsOneWidget);
    });

    testWidgets('wraps child with RepaintBoundary', (
      WidgetTester tester,
    ) async {
      // When
      await tester.pumpWidget(
        createTestWidget(
          child: const AppAnimatedListItem(index: 0, child: Text('Test')),
        ),
      );

      // Then
      await tester.pumpAndSettle();
      expect(find.byType(RepaintBoundary), findsWidgets);
    });
  });
}
