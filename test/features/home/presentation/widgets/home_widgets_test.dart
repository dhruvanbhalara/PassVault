import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/home/presentation/widgets/home_widgets.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockCallback extends Mock {
  void call();
}

void main() {
  late PasswordEntry testEntry;

  setUp(() {
    testEntry = PasswordEntry(
      id: '1',
      appName: 'Test App',
      username: 'testuser',
      password: 'password123',
      lastUpdated: DateTime.now(),
    );
  });

  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('$PasswordListTile', () {
    testWidgets('renders entry details', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          PasswordListTile(entry: testEntry, onTap: () {}, onDismissed: () {}),
        ),
      );

      expect(find.text('Test App'), findsOneWidget);
      expect(find.text('testuser'), findsOneWidget);
      expect(find.text('T'), findsOneWidget); // Leading icon text
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      final onTap = MockCallback();
      await tester.pumpWidget(
        wrapWithMaterial(
          PasswordListTile(
            entry: testEntry,
            onTap: onTap.call,
            onDismissed: () {},
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      verify(() => onTap()).called(1);
    });
  });

  group('$EmptyPasswordState', () {
    testWidgets('renders empty message', (WidgetTester tester) async {
      await tester.pumpWidget(wrapWithMaterial(const EmptyPasswordState()));
      expect(find.text('No passwords yet.\nTap + to add one.'), findsOneWidget);
    });
  });
}
