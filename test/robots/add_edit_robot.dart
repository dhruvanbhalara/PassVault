import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class AddEditRobot {
  final WidgetTester tester;

  AddEditRobot(this.tester);

  Future<void> enterAppName(String appName) async {
    final field = find.byKey(const Key('add_edit_app_name_field'));
    expect(field, findsOneWidget);
    await tester.enterText(field, appName);
    await tester.pump();
  }

  Future<void> enterUsername(String username) async {
    final field = find.byKey(const Key('add_edit_username_field'));
    expect(field, findsOneWidget);
    await tester.enterText(field, username);
    await tester.pump();
  }

  Future<void> enterPassword(String password) async {
    final field = find.byKey(const Key('add_edit_password_field'));
    expect(field, findsOneWidget);
    await tester.enterText(field, password);
    await tester.pump();
  }

  Future<void> tapSaveButton() async {
    final button = find.byKey(const Key('add_edit_save_button'));
    expect(button, findsOneWidget);
    await tester.tap(button);
    await tester.pump();
  }

  Future<void> tapVisibilityToggle() async {
    final toggle = find.byKey(const Key('add_edit_visibility_toggle'));
    expect(toggle, findsOneWidget);
    await tester.tap(toggle);
    await tester.pump();
  }

  Future<void> tapGenerateButton() async {
    final button = find.byKey(const Key('add_edit_generate_button'));
    expect(button, findsOneWidget);
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pump();
  }

  void expectAppName(String appName) {
    expect(find.text(appName), findsOneWidget);
  }

  void expectUsername(String username) {
    expect(find.text(username), findsOneWidget);
  }

  void expectPassword(String password) {
    expect(find.text(password), findsOneWidget);
  }

  void expectFieldsVisible() {
    expect(find.byKey(const Key('add_edit_app_name_field')), findsOneWidget);
    expect(find.byKey(const Key('add_edit_username_field')), findsOneWidget);
    expect(find.byKey(const Key('add_edit_password_field')), findsOneWidget);
  }

  void expectSaveButtonVisible() {
    expect(find.byKey(const Key('add_edit_save_button')), findsOneWidget);
  }

  void expectGenerateButtonVisible() {
    expect(find.byKey(const Key('add_edit_generate_button')), findsOneWidget);
  }
}
