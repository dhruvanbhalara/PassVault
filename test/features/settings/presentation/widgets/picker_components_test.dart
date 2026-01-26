import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/presentation/widgets/picker_components.dart';
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

  group('$PickerOption', () {
    testWidgets('renders title and subtitle', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        wrapWithMaterial(
          PickerOption(
            icon: Icons.add,
            color: Colors.blue,
            title: 'Option Title',
            subtitle: 'Option Subtitle',
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Option Title'), findsOneWidget);
      expect(find.text('Option Subtitle'), findsOneWidget);

      await tester.tap(find.byType(ListTile));
      expect(tapped, isTrue);
    });
  });

  group('$PickerDragHandle', () {
    testWidgets('renders container', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(const PickerDragHandle()));
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
