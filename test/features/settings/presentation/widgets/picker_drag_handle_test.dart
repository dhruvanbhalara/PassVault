import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/presentation/widgets/picker_drag_handle.dart';
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

  group('$PickerDragHandle', () {
    testWidgets('renders container', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(const PickerDragHandle()));
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
