import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/features/onboarding/presentation/widgets/intro_slide.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  const introTitle = 'Welcome';
  const introDescription = 'PassVault is secure';
  const introIcon = LucideIcons.lock;

  group('$IntroSlide', () {
    testWidgets('renders title, description and icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpApp(
        const IntroSlide(
          title: introTitle,
          description: introDescription,
          icon: introIcon,
        ),
      );

      expect(find.text(introTitle), findsOneWidget);
      expect(find.text(introDescription), findsOneWidget);
      expect(find.byIcon(introIcon), findsOneWidget);
    });
  });
}
