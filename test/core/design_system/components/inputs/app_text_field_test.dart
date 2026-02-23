import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/inputs/app_text_field.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  const testLabel = 'Test Label';
  const testHint = 'Test Hint';
  const fieldLabel = 'Field Label';
  const secretValue = 'secret';

  group('$AppTextField', () {
    testWidgets('renders label and hint', (WidgetTester tester) async {
      await tester.pumpApp(
        const AppTextField(label: testLabel, hint: testHint),
      );

      expect(find.text(testLabel), findsOneWidget);
      expect(find.text(testHint), findsOneWidget);
    });

    testWidgets('handles text entry and visibility toggle', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      bool obscureText = true;

      await tester.pumpApp(
        StatefulBuilder(
          builder: (context, setState) => AppTextField(
            label: fieldLabel,
            controller: controller,
            obscureText: obscureText,
            suffixIcon: IconButton(
              icon: const Icon(LucideIcons.eye),
              onPressed: () => setState(() => obscureText = !obscureText),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), secretValue);

      expect(controller.text, secretValue);
      var textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isFalse);
    });
  });
}
