import 'package:passvault/features/generator/presentation/widgets/generator_control_widgets.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$LengthStepperButton', () {
    testWidgets('renders icon and calls onTap when enabled', (tester) async {
      var tapped = false;
      await tester.pumpApp(
        LengthStepperButton(
          icon: Icons.add,
          isEnabled: true,
          onTap: () => tapped = true,
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap when disabled', (tester) async {
      var tapped = false;
      await tester.pumpApp(
        LengthStepperButton(
          icon: Icons.remove,
          isEnabled: false,
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(tapped, isFalse);
    });
  });

  group('$GeneratorToggleTile', () {
    testWidgets('renders label and toggle switch', (tester) async {
      await tester.pumpApp(
        GeneratorToggleTile(
          label: 'Test Label',
          value: true,
          onChanged: (_) {},
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('renders subtitle when provided', (tester) async {
      await tester.pumpApp(
        GeneratorToggleTile(
          label: 'Label',
          subtitle: 'Subtitle Text',
          value: false,
          onChanged: (_) {},
        ),
      );

      expect(find.text('Subtitle Text'), findsOneWidget);
    });

    testWidgets('calls onChanged when toggled', (tester) async {
      bool? changedValue;
      await tester.pumpApp(
        GeneratorToggleTile(
          label: 'Toggle',
          value: false,
          onChanged: (value) => changedValue = value,
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(changedValue, isTrue);
    });
  });
}
