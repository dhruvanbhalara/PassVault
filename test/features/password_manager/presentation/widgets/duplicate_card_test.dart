import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/presentation/widgets/duplicate_card.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockOnChoiceChanged extends Mock {
  void call(DuplicateResolutionChoice choice);
}

void main() {
  late DuplicatePasswordEntry testDuplicate;

  setUp(() {
    testDuplicate = DuplicatePasswordEntry(
      existingEntry: PasswordEntry(
        id: '1',
        appName: 'Test App',
        username: 'testuser',
        password: 'password',
        lastUpdated: DateTime.now(),
      ),
      newEntry: PasswordEntry(
        id: '2',
        appName: 'Test App',
        username: 'testuser',
        password: 'new_password',
        lastUpdated: DateTime.now(),
      ),
      conflictReason: 'Username already exists',
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

  group('$DuplicateCard', () {
    testWidgets('renders all duplicate information', (
      WidgetTester tester,
    ) async {
      final onChoiceChanged = MockOnChoiceChanged();
      await tester.pumpWidget(
        wrapWithMaterial(
          DuplicateCard(
            duplicate: testDuplicate,
            onChoiceChanged: onChoiceChanged.call,
          ),
        ),
      );

      expect(find.text('Test App'), findsOneWidget);
      expect(find.textContaining('testuser'), findsOneWidget);
      expect(find.text('Username already exists'), findsOneWidget);
    });

    testWidgets('calls onChoiceChanged when a resolution is selected', (
      WidgetTester tester,
    ) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      final onChoiceChanged = MockOnChoiceChanged();
      await tester.pumpWidget(
        wrapWithMaterial(
          DuplicateCard(
            duplicate: testDuplicate,
            onChoiceChanged: onChoiceChanged.call,
          ),
        ),
      );

      await tester.tap(find.text(l10n.keepExistingTitle));
      await tester.pumpAndSettle();

      verify(
        () => onChoiceChanged.call(DuplicateResolutionChoice.keepExisting),
      ).called(1);
    });
  });
}
