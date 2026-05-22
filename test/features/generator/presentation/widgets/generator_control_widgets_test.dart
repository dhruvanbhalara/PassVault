import 'package:passvault/features/generator/presentation/widgets/generator_control_widgets.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
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
