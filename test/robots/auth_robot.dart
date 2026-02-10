import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/components/components.dart';

class AuthRobot {
  final WidgetTester tester;

  AuthRobot(this.tester);

  // Finders
  final loadingFinder = find.byKey(const Key('auth_loading'));
  final unlockButtonFinder = find.byKey(const Key('auth_unlock_button'));

  // Actions
  Future<void> tapUnlock() async {
    await tester.tap(unlockButtonFinder);
    await tester.pumpAndSettle();
  }

  // Assertions
  void expectLoading() {
    expect(loadingFinder, findsOneWidget);
    expect(find.byType(AppLoader), findsOneWidget);
  }

  void expectUnlockButtonVisible() {
    expect(unlockButtonFinder, findsOneWidget);
    expect(find.byType(AppButton), findsOneWidget);
  }
}
