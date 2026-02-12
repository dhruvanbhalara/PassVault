import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/inputs/app_search_bar.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppSearchBar', () {
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await getL10n();
    });

    setUp(() {
      // Stub haptic feedback platform calls so they don't fail in tests.
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            SystemChannels.platform,
            (MethodCall methodCall) async => null,
          );
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    testWidgets('renders with default hint text', (WidgetTester tester) async {
      await tester.pumpApp(const AppSearchBar());

      expect(find.text(l10n.searchPasswords), findsOneWidget);
      expect(find.byIcon(LucideIcons.search), findsOneWidget);
    });

    testWidgets('renders with custom hint text', (WidgetTester tester) async {
      await tester.pumpApp(AppSearchBar(hintText: l10n.enterUsername));

      expect(find.text(l10n.enterUsername), findsOneWidget);
    });

    testWidgets('clear button hidden when text is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(const AppSearchBar());

      expect(find.byIcon(LucideIcons.x), findsNothing);
    });

    testWidgets('clear button appears when text is entered', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      await tester.pumpApp(AppSearchBar(controller: controller));

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      expect(find.byIcon(LucideIcons.x), findsOneWidget);
    });

    testWidgets('clear button clears text and refocuses', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      String? lastChanged;

      await tester.pumpApp(
        AppSearchBar(
          controller: controller,
          onChanged: (value) => lastChanged = value,
        ),
      );

      // Enter text.
      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pump();

      expect(find.byIcon(LucideIcons.x), findsOneWidget);

      // Tap clear.
      await tester.tap(find.byIcon(LucideIcons.x));
      await tester.pump();

      expect(controller.text, isEmpty);
      expect(lastChanged, '');
      expect(find.byIcon(LucideIcons.x), findsNothing);
    });

    testWidgets('debounces onChanged callback', (WidgetTester tester) async {
      final calls = <String>[];

      await tester.pumpApp(
        AppSearchBar(
          onChanged: (value) => calls.add(value),
          debounceDuration: const Duration(milliseconds: 300),
        ),
      );

      // Type rapidly.
      await tester.enterText(find.byType(TextField), 'a');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byType(TextField), 'ab');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byType(TextField), 'abc');
      await tester.pump(const Duration(milliseconds: 100));

      // Should not have fired yet — debounce not elapsed for last input.
      expect(calls, isEmpty);

      // Wait for debounce.
      await tester.pump(const Duration(milliseconds: 300));

      // Only the final value should be reported.
      expect(calls, ['abc']);
    });

    testWidgets('onSubmitted fires on keyboard action', (
      WidgetTester tester,
    ) async {
      String? submitted;

      await tester.pumpApp(
        AppSearchBar(onSubmitted: (value) => submitted = value),
      );

      await tester.enterText(find.byType(TextField), 'query');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(submitted, 'query');
    });

    testWidgets('uses TextInputAction.search and no autocorrect', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(const AppSearchBar());

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.textInputAction, TextInputAction.search);
      expect(textField.autocorrect, isFalse);
      expect(textField.enableSuggestions, isFalse);
    });

    testWidgets('has search semantics label', (WidgetTester tester) async {
      await tester.pumpApp(const AppSearchBar());

      expect(
        find.bySemanticsLabel(l10n.searchPasswordsSemantics),
        findsOneWidget,
      );
    });

    testWidgets('applies external controller', (WidgetTester tester) async {
      final controller = TextEditingController(text: 'initial');
      await tester.pumpApp(AppSearchBar(controller: controller));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'initial');
    });

    testWidgets('renders correctly with dark theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(const AppSearchBar(), theme: AppTheme.darkTheme);

      expect(find.byType(AppSearchBar), findsOneWidget);
      expect(find.byIcon(LucideIcons.search), findsOneWidget);
    });

    testWidgets('renders correctly with AMOLED theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(const AppSearchBar(), theme: AppTheme.amoledTheme);

      expect(find.byType(AppSearchBar), findsOneWidget);
      expect(find.byIcon(LucideIcons.search), findsOneWidget);
    });

    testWidgets('respects autofocus parameter', (WidgetTester tester) async {
      await tester.pumpApp(const AppSearchBar(autofocus: true));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.autofocus, isTrue);
    });

    testWidgets('applies custom padding', (WidgetTester tester) async {
      const padding = EdgeInsets.all(16);
      await tester.pumpApp(const AppSearchBar(padding: padding));

      final paddingWidget = tester.widget<Padding>(
        find.descendant(
          of: find.byType(AppSearchBar),
          matching: find.byType(Padding).first,
        ),
      );
      expect(paddingWidget.padding, padding);
    });
  });
}
