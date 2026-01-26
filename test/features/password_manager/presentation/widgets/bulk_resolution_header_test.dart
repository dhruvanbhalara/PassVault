import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/presentation/widgets/bulk_resolution_header.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockOnChoiceChanged extends Mock {
  void call(DuplicateResolutionChoice choice);
}

void main() {
  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('$BulkResolutionHeader', () {
    testWidgets('calls onChoiceSelected for each bulk action', (
      WidgetTester tester,
    ) async {
      final onChoiceSelected = MockOnChoiceChanged();
      await tester.pumpWidget(
        wrapWithMaterial(
          BulkResolutionHeader(onChoiceSelected: onChoiceSelected.call),
        ),
      );

      await tester.tap(find.text('Keep All Existing'));
      verify(
        () => onChoiceSelected.call(DuplicateResolutionChoice.keepExisting),
      ).called(1);

      await tester.tap(find.text('Replace All'));
      verify(
        () => onChoiceSelected.call(DuplicateResolutionChoice.replaceWithNew),
      ).called(1);

      await tester.tap(find.text('Keep All Both'));
      verify(
        () => onChoiceSelected.call(DuplicateResolutionChoice.keepBoth),
      ).called(1);
    });
  });
}
