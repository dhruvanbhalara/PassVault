import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/buttons/app_button.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppButton', () {
    testWidgets('renders text correctly', (tester) async {
      final l10n = await getL10n();
      await tester.pumpApp(AppButton(text: l10n.save, onPressed: null));

      expect(find.text(l10n.save), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      final l10n = await getL10n();
      await tester.pumpApp(
        AppButton(text: l10n.save, icon: LucideIcons.plus, onPressed: null),
      );

      expect(find.byIcon(LucideIcons.plus), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (
      tester,
    ) async {
      final l10n = await getL10n();
      await tester.pumpApp(
        AppButton(text: l10n.loading, isLoading: true, onPressed: null),
        usePumpAndSettle: false,
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(l10n.loading), findsNothing);
    });

    testWidgets('calls onPressed when clicked', (tester) async {
      final l10n = await getL10n();
      bool pressed = false;
      await tester.pumpApp(
        AppButton(text: l10n.save, onPressed: () => pressed = true),
      );

      await tester.tap(find.byType(AppButton));

      expect(pressed, true);
    });

    testWidgets('disabled when isLoading is true', (tester) async {
      final l10n = await getL10n();
      bool pressed = false;
      await tester.pumpApp(
        AppButton(
          text: l10n.loading,
          isLoading: true,
          onPressed: () => pressed = true,
        ),
        usePumpAndSettle: false,
      );

      await tester.tap(find.byType(AppButton));

      expect(pressed, false);
    });
  });
}
