import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class OnboardingRobot {
  final WidgetTester tester;

  OnboardingRobot(this.tester);

  // Finders
  final pageViewFinder = find.byKey(const Key('intro_page_view'));
  final skipButtonFinder = find.byKey(const Key('intro_skip_button'));
  final nextButtonFinder = find.byKey(const Key('intro_next_button'));
  final getStartedButtonFinder = find.byKey(
    const Key('intro_get_started_button'),
  );

  // Actions
  Future<void> tapNext() async {
    await tester.tap(nextButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapSkip() async {
    await tester.tap(skipButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapGetStarted() async {
    await tester.tap(getStartedButtonFinder);
    await tester.pumpAndSettle();
  }

  // Assertions
  void expectPageViewVisible() {
    expect(pageViewFinder, findsOneWidget);
  }

  void expectSkipButtonVisible() {
    expect(skipButtonFinder, findsOneWidget);
  }

  void expectNextButtonVisible() {
    expect(nextButtonFinder, findsOneWidget);
  }

  void expectGetStartedButtonVisible() {
    expect(getStartedButtonFinder, findsOneWidget);
  }
}
