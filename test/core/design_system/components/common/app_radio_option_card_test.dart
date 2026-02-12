import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/common/app_radio_option_card.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppRadioOptionCard', () {
    late AppLocalizations l10n;
    const title = 'Encrypted Vault';
    const description = 'AES-256 encrypted, password protected';
    const icon = Icons.lock;

    setUpAll(() async {
      l10n = await getL10n();
    });

    Widget buildCard({
      bool isSelected = false,
      VoidCallback? onTap,
      String? badgeText,
      Color? badgeColor,
      ThemeData? theme,
    }) {
      return AppRadioOptionCard(
        icon: icon,
        title: title,
        description: description,
        isSelected: isSelected,
        onTap: onTap,
        badgeText: badgeText,
        badgeColor: badgeColor,
      );
    }

    testWidgets('renders title and description', (WidgetTester tester) async {
      await tester.pumpApp(buildCard());

      expect(find.text(title), findsOneWidget);
      expect(find.text(description), findsOneWidget);
    });

    testWidgets('renders the leading icon', (WidgetTester tester) async {
      await tester.pumpApp(buildCard());

      expect(find.byIcon(icon), findsOneWidget);
    });

    testWidgets('shows unchecked radio when not selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(buildCard(isSelected: false));

      expect(find.byIcon(LucideIcons.circle), findsOneWidget);
      expect(find.byIcon(LucideIcons.circleDot), findsNothing);
    });

    testWidgets('shows checked radio when selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(buildCard(isSelected: true));

      expect(find.byIcon(LucideIcons.circleDot), findsOneWidget);
      expect(find.byIcon(LucideIcons.circle), findsNothing);
    });

    testWidgets('hides badge when badgeText is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(buildCard(badgeText: null));

      expect(find.text('Recommended'), findsNothing);
    });

    testWidgets('shows badge when badgeText is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(buildCard(badgeText: 'Recommended'));

      expect(find.text('Recommended'), findsOneWidget);
    });

    testWidgets('calls onTap when card is tapped', (WidgetTester tester) async {
      var tapped = false;
      await tester.pumpApp(buildCard(onTap: () => tapped = true));

      await tester.tap(find.byType(AppRadioOptionCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('does not crash when onTap is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(buildCard(onTap: null));

      await tester.tap(find.byType(AppRadioOptionCard));
      await tester.pumpAndSettle();
      // No assertion needed – just verifying no exception.
    });

    testWidgets('has correct semantics when not selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(buildCard(isSelected: false));

      final semantics = tester.getSemantics(find.byType(AppRadioOptionCard));
      expect(semantics.label, contains(title));
      expect(semantics.label, contains(description));
      expect(semantics.label, contains(l10n.notSelectedState));
    });

    testWidgets('has correct semantics when selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(buildCard(isSelected: true));

      final semantics = tester.getSemantics(find.byType(AppRadioOptionCard));
      expect(semantics.label, contains(l10n.selectedState));
    });

    testWidgets('includes badge in semantic label', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(buildCard(badgeText: 'Recommended'));

      final semantics = tester.getSemantics(find.byType(AppRadioOptionCard));
      expect(semantics.label, contains('Recommended'));
    });

    testWidgets('renders in dark theme without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        buildCard(isSelected: true, badgeText: 'Recommended'),
        theme: AppTheme.darkTheme,
      );

      expect(find.byType(AppRadioOptionCard), findsOneWidget);
    });

    testWidgets('renders in AMOLED theme without errors', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        buildCard(isSelected: true, badgeText: 'Recommended'),
        theme: AppTheme.amoledTheme,
      );

      expect(find.byType(AppRadioOptionCard), findsOneWidget);
    });

    testWidgets('renders multiple cards in a list', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        Column(
          children: [
            buildCard(isSelected: true, badgeText: 'Recommended'),
            buildCard(isSelected: false),
            AppRadioOptionCard(
              icon: Icons.table_chart,
              title: 'CSV Spreadsheet',
              description: 'Unencrypted, for Excel/Sheets',
              isSelected: false,
              onTap: () {},
            ),
          ],
        ),
      );

      expect(find.byType(AppRadioOptionCard), findsNWidgets(3));
    });
  });
}
