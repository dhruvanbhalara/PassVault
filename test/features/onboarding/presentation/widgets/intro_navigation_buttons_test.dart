import 'package:passvault/features/onboarding/presentation/widgets/intro_navigation_buttons.dart';
import 'package:passvault/features/onboarding/presentation/widgets/intro_pagination_indicator.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$IntroNavigationButtons', () {
    testWidgets('renders pagination and buttons', (tester) async {
      final l10n = await getL10n();
      bool skipPressed = false;
      bool nextPressed = false;

      await tester.pumpApp(
        IntroNavigationButtons(
          currentPage: 0,
          totalPages: 3,
          onSkip: () => skipPressed = true,
          onNext: () => nextPressed = true,
        ),
      );

      expect(find.text(l10n.skip), findsOneWidget);
      expect(find.text(l10n.next), findsOneWidget);
      expect(find.byType(IntroPaginationIndicator), findsOneWidget);

      await tester.tap(find.text(l10n.skip));
      expect(skipPressed, isTrue);

      await tester.tap(find.text(l10n.next));
      expect(nextPressed, isTrue);
    });

    testWidgets('shows Done instead of Next on last page', (tester) async {
      final l10n = await getL10n();

      await tester.pumpApp(
        IntroNavigationButtons(
          currentPage: 2,
          totalPages: 3,
          onSkip: () {},
          onNext: () {},
        ),
      );

      expect(find.text(l10n.done), findsOneWidget);
      expect(find.text(l10n.skip), findsNothing);
    });
  });
}
