import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/components/buttons/app_button.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('AppButton', () {
    testWidgets('renders text correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AppButton(text: 'Click Me', onPressed: null),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AppButton(
            text: 'Icon Button',
            icon: Icons.add,
            onPressed: null,
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AppButton(
            text: 'Loading',
            isLoading: true,
            onPressed: null,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('calls onPressed when clicked', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: AppButton(text: 'Click Me', onPressed: () => pressed = true),
        ),
      );

      await tester.tap(find.byType(AppButton));
      expect(pressed, true);
    });

    testWidgets('disabled when isLoading is true', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: AppButton(
            text: 'Loading',
            isLoading: true,
            onPressed: () => pressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(AppButton));
      expect(pressed, false);
    });
  });
}
