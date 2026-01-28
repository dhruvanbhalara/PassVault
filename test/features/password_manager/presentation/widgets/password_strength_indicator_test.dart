import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/widgets/password_strength_indicator.dart';
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

  group('$PasswordStrengthIndicator', () {
    testWidgets('shows correct percentage text', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithMaterial(const PasswordStrengthIndicator(strength: 0.75)),
      );

      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('shows LinearProgressIndicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithMaterial(const PasswordStrengthIndicator(strength: 0.5)),
      );

      final progressFinder = find.byType(LinearProgressIndicator);
      expect(progressFinder, findsOneWidget);
      final progress = tester.widget<LinearProgressIndicator>(progressFinder);
      expect(progress.value, 0.5);
    });
  });
}
