import 'package:passvault/core/design_system/components/inputs/app_text_field.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppTextField', () {
    testWidgets('renders label and hint', (WidgetTester tester) async {
      await tester.pumpApp(
        const AppTextField(label: 'Test Label', hint: 'Test Hint'),
      );

      expect(find.text('TEST LABEL'), findsOneWidget);
      expect(find.text('Test Hint'), findsOneWidget);
    });

    testWidgets('handles text entry and visibility toggle', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      bool obscureText = true;

      await tester.pumpApp(
        StatefulBuilder(
          builder: (context, setState) => AppTextField(
            label: 'Field Label',
            controller: controller,
            obscureText: obscureText,
            suffixIcon: IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () => setState(() => obscureText = !obscureText),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'secret');

      expect(controller.text, 'secret');
      var textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isFalse);
    });
  });
}
