import 'package:passvault/core/design_system/components/feedback/app_loader.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppLoader', () {
    testWidgets('renders CircularProgressIndicator', (tester) async {
      await tester.pumpApp(const AppLoader(), usePumpAndSettle: false);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('uses custom size', (tester) async {
      const size = 50.0;

      await tester.pumpApp(
        const AppLoader(size: size),
        usePumpAndSettle: false,
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AppLoader),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.height, size);
      expect(sizedBox.width, size);
    });
  });
}
