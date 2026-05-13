import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/feedback/app_loader.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppLoader', () {
    testWidgets('renders pulsing shield icon', (tester) async {
      await tester.pumpApp(const AppLoader(), usePumpAndSettle: false);

      expect(find.byIcon(LucideIcons.shieldCheck), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('respects custom size', (tester) async {
      const size = 50.0;

      await tester.pumpApp(
        const AppLoader(size: size),
        usePumpAndSettle: false,
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppLoader),
          matching: find.byType(Container),
        ),
      );
      expect(container.constraints?.minWidth, size);
      expect(container.constraints?.minHeight, size);
    });
  });
}
