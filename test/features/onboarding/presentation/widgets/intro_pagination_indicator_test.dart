import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/onboarding/presentation/widgets/intro_pagination_indicator.dart';

void main() {
  group('$IntroPaginationIndicator', () {
    testWidgets('renders correct number of indicators', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: IntroPaginationIndicator(count: 3, currentPage: 0),
          ),
        ),
      );

      expect(find.byType(AnimatedContainer), findsNWidgets(3));
    });
  });
}
