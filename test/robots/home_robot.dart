import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class HomeRobot {
  final WidgetTester tester;

  HomeRobot(this.tester);

  // Finders
  final fabFinder = find.byKey(const Key('home_fab'));
  final settingsButtonFinder = find.byKey(const Key('home_settings_button'));
  final loadingFinder = find.byKey(const Key('home_loading'));
  final emptyTextFinder = find.byKey(const Key('home_empty_text'));
  final passwordListFinder = find.byKey(const Key('home_password_list'));

  // Actions
  Future<void> tapAddPassword() async {
    await tester.tap(fabFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapSettings() async {
    await tester.tap(settingsButtonFinder);
    await tester.pumpAndSettle();
  }

  // Assertions
  void expectEmptyState() {
    expect(emptyTextFinder, findsOneWidget);
  }

  void expectLoading() {
    expect(loadingFinder, findsOneWidget);
  }

  void expectPasswordListVisible() {
    expect(passwordListFinder, findsOneWidget);
  }

  void expectPasswordVisible(String appName) {
    expect(find.text(appName), findsOneWidget);
  }

  void expectPasswordsCount(int count) {
    // This assumes specific items are rendered, maybe checking by type
    // or looking for children in the scroll view
    expect(find.byType(ListTile), findsNWidgets(count));
  }
}
