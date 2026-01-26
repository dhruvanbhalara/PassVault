import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/home/presentation/widgets/empty_password_state.dart';
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

  group('$EmptyPasswordState', () {
    testWidgets('renders empty message', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(const EmptyPasswordState()));
      expect(find.text('No passwords yet.\nTap + to add one.'), findsOneWidget);
    });
  });
}
