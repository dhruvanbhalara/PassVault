import 'package:passvault/core/design_system/components/common/app_section_header.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppSectionHeader', () {
    testWidgets('renders simple variant by default', (
      WidgetTester tester,
    ) async {
      const title = 'Recent Passwords';

      await tester.pumpApp(const AppSectionHeader(title: title));

      expect(find.text(title.toUpperCase()), findsOneWidget);
    });

    testWidgets('renders premium variant with divider', (
      WidgetTester tester,
    ) async {
      const title = 'Security Settings';

      await tester.pumpApp(
        const AppSectionHeader(
          title: title,
          variant: AppSectionHeaderVariant.premium,
        ),
      );

      expect(find.text(title.toUpperCase()), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('renders trailing widget when provided', (
      WidgetTester tester,
    ) async {
      const trailing = Icon(Icons.more_vert);

      await tester.pumpApp(
        const AppSectionHeader(title: 'Title', trailing: trailing),
      );

      expect(find.byWidget(trailing), findsOneWidget);
    });

    testWidgets('simple variant does not show divider', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const AppSectionHeader(
          title: 'Test',
          variant: AppSectionHeaderVariant.simple,
        ),
      );

      expect(find.byType(AppSectionHeader), findsOneWidget);
      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('premium variant shows divider', (WidgetTester tester) async {
      await tester.pumpApp(
        const AppSectionHeader(
          title: 'Test',
          variant: AppSectionHeaderVariant.premium,
        ),
      );

      expect(find.byType(AppSectionHeader), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });
  });
}
