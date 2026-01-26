import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/presentation/widgets/settings_shared_widgets.dart';

void main() {
  group('$SettingsSectionHeader', () {
    testWidgets('displays title in uppercase', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: SettingsSectionHeader(title: 'Security')),
        ),
      );

      expect(find.text('SECURITY'), findsOneWidget);
    });
  });

  group('$SettingsMetricIcon', () {
    testWidgets('displays icon with correct color', (tester) async {
      const testIcon = Icons.lock;
      const testColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: SettingsMetricIcon(icon: testIcon, color: testColor),
          ),
        ),
      );

      final iconFinder = find.byIcon(testIcon);
      expect(iconFinder, findsOneWidget);

      final iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.color, testColor);
    });
  });
}
