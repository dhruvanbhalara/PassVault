import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/components/inputs/app_text_field.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

void main() {
  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: child),
    );
  }

  group('$AppTextField', () {
    testWidgets('renders label and hint', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          const AppTextField(label: 'Test Label', hint: 'Test Hint'),
        ),
      );

      expect(find.text('TEST LABEL'), findsOneWidget);
      expect(find.text('Test Hint'), findsOneWidget);
    });

    testWidgets('handles text entry and visibility toggle', (
      WidgetTester tester,
    ) async {
      final controller = TextEditingController();
      bool obscureText = true;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => wrapWithMaterial(
            AppTextField(
              label: 'Field Label',
              controller: controller,
              obscureText: obscureText,
              suffixIcon: IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () => setState(() => obscureText = !obscureText),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'secret');
      expect(controller.text, 'secret');

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      final updatedTextField = tester.widget<TextField>(find.byType(TextField));
      expect(updatedTextField.obscureText, isFalse);
    });
  });
}
