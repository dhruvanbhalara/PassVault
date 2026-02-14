import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class ExportVaultRobot {
  final WidgetTester tester;

  ExportVaultRobot(this.tester);

  // Finders
  final jsonOptionFinder = find.byKey(const Key('export_format_json_option'));
  final csvOptionFinder = find.byKey(const Key('export_format_csv_option'));
  final encryptSwitchFinder = find.byKey(const Key('export_encrypt_switch'));
  final passwordFieldFinder = find.byKey(const Key('export_password_field'));
  final exportButtonFinder = find.byKey(const Key('export_button'));

  // Actions
  Future<void> selectJsonFormat() async {
    await tester.ensureVisible(jsonOptionFinder);
    await tester.tap(jsonOptionFinder);
    await tester.pumpAndSettle();
  }

  Future<void> selectCsvFormat() async {
    await tester.ensureVisible(csvOptionFinder);
    await tester.tap(csvOptionFinder);
    await tester.pumpAndSettle();
  }

  Future<void> toggleEncryption(bool value) async {
    final switchWidget = tester.widget<SwitchListTile>(encryptSwitchFinder);
    if (switchWidget.value != value) {
      await tester.ensureVisible(encryptSwitchFinder);
      await tester.tap(encryptSwitchFinder);
      await tester.pumpAndSettle();
    }
  }

  Future<void> enterPassword(String password) async {
    await tester.ensureVisible(passwordFieldFinder);
    await tester.enterText(passwordFieldFinder, password);
    await tester.pumpAndSettle();
  }

  Future<void> tapExport() async {
    await tester.ensureVisible(exportButtonFinder);
    await tester.tap(exportButtonFinder);
    await tester.pumpAndSettle();
  }

  // Assertions
  void expectPasswordFieldVisible(bool visible) {
    if (visible) {
      expect(passwordFieldFinder, findsOneWidget);
    } else {
      expect(passwordFieldFinder, findsNothing);
    }
  }

  void expectSnackBarContaining(String text) {
    expect(find.textContaining(text, skipOffstage: false), findsOneWidget);
  }
}
