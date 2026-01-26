import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/onboarding/presentation/widgets/intro_navigation_buttons.dart';
import 'package:passvault/features/onboarding/presentation/widgets/intro_pagination_indicator.dart';
import 'package:passvault/l10n/app_localizations.dart';

void main() {
  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('$IntroNavigationButtons', () {
    testWidgets('renders pagination and buttons', (WidgetTester tester) async {
      bool skipPressed = false;
      bool nextPressed = false;

      await tester.pumpWidget(
        wrapWithMaterial(
          IntroNavigationButtons(
            currentPage: 0,
            totalPages: 3,
            onSkip: () => skipPressed = true,
            onNext: () => nextPressed = true,
          ),
        ),
      );

      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.byType(IntroPaginationIndicator), findsOneWidget);

      await tester.tap(find.text('Skip'));
      expect(skipPressed, isTrue);

      await tester.tap(find.text('Next'));
      expect(nextPressed, isTrue);
    });

    testWidgets('shows Done instead of Next on last page', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          IntroNavigationButtons(
            currentPage: 2,
            totalPages: 3,
            onSkip: () {},
            onNext: () {},
          ),
        ),
      );

      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Skip'), findsNothing);
    });
  });
}
