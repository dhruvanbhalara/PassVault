import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/presentation/widgets/settings_metric_icon.dart';

void main() {
  group('$SettingsMetricIcon', () {
    testWidgets('displays icon with correct color', (tester) async {
      const testIcon = LucideIcons.lock;
      const testColor = AppColors.errorLight;

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
