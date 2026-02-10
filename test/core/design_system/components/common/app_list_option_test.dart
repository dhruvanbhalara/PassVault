import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/common/app_list_option.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('$AppListOption', () {
    testWidgets('renders title, subtitle, icon, and chevron', (
      WidgetTester tester,
    ) async {
      // Given
      const title = 'Export JSON';
      const subtitle = 'Backup in JSON format';
      var tapped = false;

      // When
      await tester.pumpWidget(
        createTestWidget(
          child: AppListOption(
            icon: LucideIcons.braces,
            iconColor: Colors.blue,
            title: title,
            subtitle: subtitle,
            onTap: () => tapped = true,
          ),
        ),
      );

      // Then
      expect(find.text(title), findsOneWidget);
      expect(find.text(subtitle), findsOneWidget);
      expect(find.byIcon(LucideIcons.braces), findsOneWidget);
      expect(find.byIcon(LucideIcons.chevronRight), findsOneWidget);

      // When tapping
      await tester.tap(find.byType(AppListOption));
      await tester.pumpAndSettle();

      // Then
      expect(tapped, isTrue);
    });

    testWidgets('renders custom trailing widget when provided', (
      WidgetTester tester,
    ) async {
      // Given
      const trailing = Icon(Icons.check);

      // When
      await tester.pumpWidget(
        createTestWidget(
          child: AppListOption(
            icon: LucideIcons.braces,
            iconColor: Colors.blue,
            title: 'Title',
            subtitle: 'Subtitle',
            onTap: () {}, // Fixed: non-nullable callback
            trailing: trailing,
          ),
        ),
      );

      // Then
      expect(find.byType(Icon), findsNWidgets(2)); // icon + trailing
      expect(find.byIcon(LucideIcons.chevronRight), findsNothing);
    });
  });
}
