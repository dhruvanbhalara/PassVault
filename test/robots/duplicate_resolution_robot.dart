import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';

class DuplicateResolutionRobot {
  final WidgetTester tester;

  DuplicateResolutionRobot(this.tester);

  // Finders
  final resolveButtonFinder = find.byKey(
    const Key('resolve_duplicates_button'),
  );
  final loaderFinder = find.byType(AppLoader);

  // Actions
  Future<void> tapResolve() async {
    await tester.tap(resolveButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> tapChoice(String label) async {
    final choiceFinder = find.text(label).first;
    await tester.ensureVisible(choiceFinder);
    await tester.pumpAndSettle();
    await tester.tap(choiceFinder, warnIfMissed: false);
    await tester.pumpAndSettle();
  }

  // Assertions
  void expectResolveButtonDisabled() {
    final ignorePointerFinder = find
        .ancestor(of: resolveButtonFinder, matching: find.byType(IgnorePointer))
        .first;
    expect(ignorePointerFinder, findsOneWidget);
    final ignorePointer = tester.widget<IgnorePointer>(ignorePointerFinder);
    expect(ignorePointer.ignoring, isTrue);
  }

  void expectResolveButtonEnabled() {
    final ignorePointerFinder = find
        .ancestor(of: resolveButtonFinder, matching: find.byType(IgnorePointer))
        .first;
    expect(ignorePointerFinder, findsOneWidget);
    final ignorePointer = tester.widget<IgnorePointer>(ignorePointerFinder);
    expect(ignorePointer.ignoring, isFalse);
  }

  void expectResolveButtonLoading() {
    final button = tester.widget<AppButton>(resolveButtonFinder);
    expect(button.isLoading, isTrue);
  }

  void expectLoaderVisible() {
    expect(loaderFinder, findsOneWidget);
  }

  void expectTextVisible(String text) {
    expect(find.text(text), findsWidgets);
  }

  void expectChoiceSelected(
    DuplicateResolutionChoice choice,
    int expectedCount,
  ) {
    final replaceRadios = find.byWidgetPredicate(
      (widget) =>
          widget is RadioListTile<DuplicateResolutionChoice> &&
          widget.value == choice,
    );
    expect(replaceRadios, findsNWidgets(expectedCount));

    for (final radioFinder in replaceRadios.evaluate()) {
      final radioGroup = tester.widget<RadioGroup<DuplicateResolutionChoice>>(
        find
            .ancestor(
              of: find.byWidget(radioFinder.widget),
              matching: find.byType(RadioGroup<DuplicateResolutionChoice>),
            )
            .first,
      );
      expect(radioGroup.groupValue, choice);
    }
  }
}
