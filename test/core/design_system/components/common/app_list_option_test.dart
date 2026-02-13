import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/common/app_list_option.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  const title = 'Export JSON';
  const subtitle = 'Backup in JSON format';

  group('$AppListOption', () {
    testWidgets('renders title, subtitle, icon, and chevron', (
      WidgetTester tester,
    ) async {
      var tapped = false;

      await tester.pumpApp(
        AppListOption(
          icon: LucideIcons.braces,
          iconColor: AppColors.primaryLight,
          title: title,
          subtitle: subtitle,
          onTap: () => tapped = true,
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
      expect(find.byIcon(LucideIcons.braces), findsOneWidget);
      expect(find.byIcon(LucideIcons.chevronRight), findsOneWidget);

      await tester.tap(find.byType(AppListOption));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('renders custom trailing widget when provided', (
      WidgetTester tester,
    ) async {
      const trailing = Icon(LucideIcons.check);

      await tester.pumpApp(
        AppListOption(
          icon: LucideIcons.braces,
          iconColor: AppColors.primaryLight,
          title: title,
          subtitle: subtitle,
          onTap: () {},
          trailing: trailing,
        ),
      );

      expect(find.byType(Icon), findsNWidgets(2)); // icon + trailing
      expect(find.byIcon(LucideIcons.chevronRight), findsNothing);
    });
  });
}
