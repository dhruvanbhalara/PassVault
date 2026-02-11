import 'package:passvault/core/design_system/components/buttons/app_text_button.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppTextButton', () {
    testWidgets('renders text correctly', (tester) async {
      await tester.pumpApp(
        const AppTextButton(text: 'Click Me', onPressed: null),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('calls onPressed when clicked', (tester) async {
      bool pressed = false;
      await tester.pumpApp(
        AppTextButton(text: 'Click Me', onPressed: () => pressed = true),
      );

      await tester.tap(find.byType(AppTextButton));

      expect(pressed, true);
    });
  });
}
