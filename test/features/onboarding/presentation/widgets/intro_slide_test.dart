import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/onboarding/presentation/widgets/intro_slide.dart';
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

  group('$IntroSlide', () {
    testWidgets('renders title, description and icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          const IntroSlide(
            title: 'Welcome',
            description: 'PassVault is secure',
            icon: Icons.lock,
          ),
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('PassVault is secure'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });
  });
}
