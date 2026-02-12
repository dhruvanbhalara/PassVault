import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class OnboardingRobot {
  final WidgetTester tester;

  OnboardingRobot(this.tester);

  // Finders
  final pageViewFinder = find.byKey(const Key('intro_page_view'));
  final nextButtonFinder = find.byKey(const Key('intro_next_button'));
  final skipButtonFinder = find.byKey(const Key('intro_skip_button'));
  final biometricEnableButtonFinder = find.byKey(
    const Key('intro_biometric_enable_button'),
  );
  final doneButtonFinder = find.byKey(const Key('intro_done_button'));

  // Actions
  Future<void> tapNext() async {
    await tester.tap(nextButtonFinder);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1)); // Wait for slide animation
  }

  Future<void> tapSkip() async {
    await tester.tap(skipButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapEnableBiometrics() async {
    await tester.ensureVisible(biometricEnableButtonFinder);
    await tester.tap(biometricEnableButtonFinder);
    await tester.pump();
  }

  Future<void> tapDone() async {
    await tester.ensureVisible(doneButtonFinder);
    await tester.tap(doneButtonFinder);
    await tester.pumpAndSettle();
  }

  // Assertions
  void expectPageViewVisible() {
    expect(pageViewFinder, findsOneWidget);
  }

  void expectNextButtonVisible() {
    expect(nextButtonFinder, findsOneWidget);
  }

  void expectSkipButtonVisible() {
    expect(skipButtonFinder, findsOneWidget);
  }
}
