import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class SettingsRobot {
  final WidgetTester tester;

  SettingsRobot(this.tester);

  // Finders
  final themeTileFinder = find.byKey(const Key('settings_theme_tile'));
  final languageTileFinder = find.byKey(const Key('settings_language_tile'));
  final exportTileFinder = find.byKey(const Key('settings_export_tile'));
  final importTileFinder = find.byKey(const Key('settings_import_tile'));
  final clearDbTileFinder = find.byKey(const Key('settings_clear_db_tile'));

  // Actions
  Future<void> tapTheme() async {
    await tester.scrollUntilVisible(
      themeTileFinder,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(themeTileFinder);
    await tester.pumpAndSettle();
    await tester.tap(themeTileFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapExport() async {
    await tester.scrollUntilVisible(
      exportTileFinder,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(exportTileFinder);
    await tester.pumpAndSettle();
    await tester.tap(exportTileFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapLanguage() async {
    await tester.scrollUntilVisible(
      languageTileFinder,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(languageTileFinder);
    await tester.pumpAndSettle();
    await tester.tap(languageTileFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapImport() async {
    await tester.scrollUntilVisible(
      importTileFinder,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(importTileFinder);
    await tester.pumpAndSettle();
    await tester.tap(importTileFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapClearDb() async {
    await tester.scrollUntilVisible(
      clearDbTileFinder,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(clearDbTileFinder);
    await tester.pumpAndSettle();
    await tester.tap(clearDbTileFinder);
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
