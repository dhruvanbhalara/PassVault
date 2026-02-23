import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/common/app_icon_badge.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppIconBadge', () {
    testWidgets('renders icon with colored background', (
      WidgetTester tester,
    ) async {
      const icon = LucideIcons.lock;
      const color = AppColors.primaryLight;

      await tester.pumpApp(const AppIconBadge(icon: icon, color: color));

      expect(find.byIcon(icon), findsOneWidget);
      final iconWidget = tester.widget<Icon>(find.byIcon(icon));
      expect(iconWidget.color, color);
    });

    testWidgets('renders different sizes correctly', (
      WidgetTester tester,
    ) async {
      final sizes = [
        AppIconBadgeSize.small,
        AppIconBadgeSize.medium,
        AppIconBadgeSize.large,
        AppIconBadgeSize.extraLarge,
      ];

      for (final size in sizes) {
        await tester.pumpApp(
          AppIconBadge(
            icon: LucideIcons.lock,
            color: AppColors.primaryLight,
            size: size,
          ),
        );

        expect(find.byType(AppIconBadge), findsOneWidget);
      }
    });

    testWidgets('uses default medium size when not specified', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const AppIconBadge(
          icon: LucideIcons.lock,
          color: AppColors.primaryLight,
        ),
      );

      final badge = tester.widget<AppIconBadge>(find.byType(AppIconBadge));
      expect(badge.size, AppIconBadgeSize.medium);
    });
  });
}
