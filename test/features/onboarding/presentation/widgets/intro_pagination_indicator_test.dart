import 'package:passvault/features/onboarding/presentation/widgets/intro_pagination_indicator.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$IntroPaginationIndicator', () {
    testWidgets('renders correct number of indicators', (tester) async {
      await tester.pumpApp(
        const IntroPaginationIndicator(count: 3, currentPage: 0),
      );

      expect(find.byType(AnimatedContainer), findsNWidgets(3));
    });

    group('Specific Indicators', () {
      testWidgets('active indicator has correct color', (tester) async {
        await tester.pumpApp(
          const IntroPaginationIndicator(count: 3, currentPage: 1),
        );

        final containers = tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .toList();

        final activeColor = AppColors.primaryLight;
        expect((containers[1].decoration as BoxDecoration).color, activeColor);
        expect(
          (containers[0].decoration as BoxDecoration).color,
          isNot(activeColor),
        );
      });
    });
  });
}
