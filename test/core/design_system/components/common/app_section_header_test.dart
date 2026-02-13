import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/common/app_section_header.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  const recentPasswordsTitle = 'Recent Passwords';
  const securitySettingsTitle = 'Security Settings';
  const genericTitle = 'Title';
  const testTitle = 'Test';

  group('$AppSectionHeader', () {
    testWidgets('renders simple variant by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(const AppSectionHeader(title: recentPasswordsTitle));

      expect(find.text(recentPasswordsTitle.toUpperCase()), findsOneWidget);
    });

    testWidgets('renders premium variant with divider', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const AppSectionHeader(
          title: securitySettingsTitle,
          variant: AppSectionHeaderVariant.premium,
        ),
      );

      expect(find.text(securitySettingsTitle.toUpperCase()), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('renders trailing widget when provided', (
      WidgetTester tester,
    ) async {
      const trailing = Icon(LucideIcons.ellipsisVertical);

      await tester.pumpApp(
        const AppSectionHeader(title: genericTitle, trailing: trailing),
      );

      expect(find.byWidget(trailing), findsOneWidget);
    });

    testWidgets('simple variant does not show divider', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const AppSectionHeader(
          title: testTitle,
          variant: AppSectionHeaderVariant.simple,
        ),
      );

      expect(find.byType(AppSectionHeader), findsOneWidget);
      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('premium variant shows divider', (WidgetTester tester) async {
      await tester.pumpApp(
        const AppSectionHeader(
          title: testTitle,
          variant: AppSectionHeaderVariant.premium,
        ),
      );

      expect(find.byType(AppSectionHeader), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });
  });
}
