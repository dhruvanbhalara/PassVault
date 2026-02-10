import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/components/common/app_section_header.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppSectionHeader', () {
    testWidgets('renders simple variant by default', (
      WidgetTester tester,
    ) async {
      // Given
      const title = 'Recent Passwords';

      // When
      await tester.pumpWidget(
        createTestWidget(child: const AppSectionHeader(title: title)),
      );

      // Then
      expect(find.text(title.toUpperCase()), findsOneWidget);
    });

    testWidgets('renders premium variant with divider', (
      WidgetTester tester,
    ) async {
      // Given
      const title = 'Security Settings';

      // When
      await tester.pumpWidget(
        createTestWidget(
          child: const AppSectionHeader(
            title: title,
            variant: AppSectionHeaderVariant.premium,
          ),
        ),
      );

      // Then
      expect(find.text(title.toUpperCase()), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('renders trailing widget when provided', (
      WidgetTester tester,
    ) async {
      // Given
      const trailing = Icon(Icons.more_vert);

      // When
      await tester.pumpWidget(
        createTestWidget(
          child: const AppSectionHeader(title: 'Title', trailing: trailing),
        ),
      );

      // Then
      expect(find.byWidget(trailing), findsOneWidget);
    });

    testWidgets('simple variant does not show divider', (
      WidgetTester tester,
    ) async {
      // When
      await tester.pumpWidget(
        createTestWidget(
          child: const AppSectionHeader(
            title: 'Test',
            variant: AppSectionHeaderVariant.simple,
          ),
        ),
      );

      // Then
      expect(find.byType(AppSectionHeader), findsOneWidget);
      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('premium variant shows divider', (WidgetTester tester) async {
      // When
      await tester.pumpWidget(
        createTestWidget(
          child: const AppSectionHeader(
            title: 'Test',
            variant: AppSectionHeaderVariant.premium,
          ),
        ),
      );

      // Then
      expect(find.byType(AppSectionHeader), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });
  });
}
