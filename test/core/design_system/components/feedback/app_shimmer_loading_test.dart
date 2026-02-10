import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/components/feedback/app_shimmer_loading.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppShimmerLoading', () {
    testWidgets('renders shimmer with default rectangle shape', (
      WidgetTester tester,
    ) async {
      // Given
      const width = 200.0;
      const height = 50.0;

      // When
      await tester.pumpWidget(
        createTestWidget(
          child: const AppShimmerLoading(width: width, height: height),
        ),
      );

      // Then
      expect(find.byType(AppShimmerLoading), findsOneWidget);
    });

    testWidgets('renders shimmer with circle shape', (
      WidgetTester tester,
    ) async {
      // Given
      const size = 50.0;

      // When
      await tester.pumpWidget(
        createTestWidget(
          child: const AppShimmerLoading(
            width: size,
            height: size,
            shape: AppShimmerShape.circle,
          ),
        ),
      );

      // Then
      expect(find.byType(AppShimmerLoading), findsOneWidget);
    });

    testWidgets('animates shimmer effect', (WidgetTester tester) async {
      // When
      await tester.pumpWidget(
        createTestWidget(
          child: const AppShimmerLoading(width: 100, height: 100),
        ),
      );

      // Pump some frames to ensure animation is running
      // We don't use pumpAndSettle because it will never end for a repeat animation.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Then - animation controller should be active and widget present
      expect(find.byType(AppShimmerLoading), findsOneWidget);
    });
  });
}
