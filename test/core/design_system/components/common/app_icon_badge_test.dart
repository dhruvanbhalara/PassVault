import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/common/app_icon_badge.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppIconBadge', () {
    testWidgets('renders icon with colored background', (
      WidgetTester tester,
    ) async {
      // Given
      const icon = LucideIcons.lock;
      const color = Colors.blue;

      // When
      await tester.pumpWidget(
        createTestWidget(
          child: const AppIconBadge(icon: icon, color: color),
        ),
      );

      // Then
      expect(find.byIcon(icon), findsOneWidget);
      final iconWidget = tester.widget<Icon>(find.byIcon(icon));
      expect(iconWidget.color, color);
    });

    testWidgets('renders different sizes correctly', (
      WidgetTester tester,
    ) async {
      // Given
      final sizes = [
        AppIconBadgeSize.small,
        AppIconBadgeSize.medium,
        AppIconBadgeSize.large,
        AppIconBadgeSize.extraLarge,
      ];

      for (final size in sizes) {
        // When
        await tester.pumpWidget(
          createTestWidget(
            child: AppIconBadge(
              icon: LucideIcons.lock,
              color: Colors.blue,
              size: size,
            ),
          ),
        );

        // Then
        expect(find.byType(AppIconBadge), findsOneWidget);

        // Clean up for next iteration
        await tester.pumpWidget(Container());
      }
    });

    testWidgets('uses default medium size when not specified', (
      WidgetTester tester,
    ) async {
      // When
      await tester.pumpWidget(
        createTestWidget(
          child: const AppIconBadge(icon: LucideIcons.lock, color: Colors.blue),
        ),
      );

      // Then
      final badge = tester.widget<AppIconBadge>(find.byType(AppIconBadge));
      expect(badge.size, AppIconBadgeSize.medium);
    });
  });
}
