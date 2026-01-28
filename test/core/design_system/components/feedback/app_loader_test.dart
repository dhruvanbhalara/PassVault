import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/components/feedback/app_loader.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppLoader', () {
    testWidgets('renders CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(createTestWidget(child: const AppLoader()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('uses custom size', (tester) async {
      await tester.pumpWidget(
        createTestWidget(child: const AppLoader(size: 50.0)),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AppLoader),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.height, 50.0);
      expect(sizedBox.width, 50.0);
    });
  });
}
