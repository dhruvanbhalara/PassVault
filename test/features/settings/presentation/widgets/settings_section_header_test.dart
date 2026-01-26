import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/presentation/widgets/settings_section_header.dart';

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
}
