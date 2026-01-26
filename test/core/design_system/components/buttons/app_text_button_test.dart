import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/components/buttons/app_text_button.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppTextButton', () {
    testWidgets('renders text correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AppTextButton(text: 'Click Me', onPressed: null),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('calls onPressed when clicked', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        createTestWidget(
          child: AppTextButton(
            text: 'Click Me',
            onPressed: () => pressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(AppTextButton));
      expect(pressed, true);
    });
  });
}
