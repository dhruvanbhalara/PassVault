import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class SettingsRobot {
  final WidgetTester tester;

  SettingsRobot(this.tester);

  // Finders
  final themeTileFinder = find.byKey(const Key('settings_theme_tile'));
  final exportTileFinder = find.byKey(const Key('settings_export_tile'));
  final importTileFinder = find.byKey(const Key('settings_import_tile'));
  final clearDbTileFinder = find.byKey(const Key('settings_clear_db_tile'));

  // Export Sheet finders
  final exportJsonTileFinder = find.byKey(const Key('export_json_tile'));
  final exportCsvTileFinder = find.byKey(const Key('export_csv_tile'));

  // Actions
  Future<void> tapTheme() async {
    await tester.tap(themeTileFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapExport() async {
    await tester.tap(exportTileFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapImport() async {
    await tester.tap(importTileFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapExportJson() async {
    await tester.tap(exportJsonTileFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapExportCsv() async {
    await tester.tap(exportCsvTileFinder);
    await tester.pumpAndSettle();
  }

  // Assertions
  void expectThemeOptionVisible(String name) {
    expect(find.text(name), findsOneWidget);
  }

  void expectSnackBarContaining(String text) {
    expect(find.textContaining(text), findsOneWidget);
  }
}
