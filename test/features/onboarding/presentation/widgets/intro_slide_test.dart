import 'package:passvault/features/onboarding/presentation/widgets/intro_slide.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$IntroSlide', () {
    testWidgets('renders title, description and icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const IntroSlide(
          title: 'Welcome',
          description: 'PassVault is secure',
          icon: Icons.lock,
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('PassVault is secure'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });
  });
}
