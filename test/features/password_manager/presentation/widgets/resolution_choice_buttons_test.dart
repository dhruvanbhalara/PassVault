import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/presentation/widgets/resolution_choice_buttons.dart';
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

  group('$ResolutionChoiceButtons', () {
    testWidgets('renders all options', (WidgetTester tester) async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      final onChoiceChanged = MockOnChoiceChanged();
      await tester.pumpWidget(
        wrapWithMaterial(
          ResolutionChoiceButtons(
            selectedChoice: DuplicateResolutionChoice.keepExisting,
            onChoiceChanged: onChoiceChanged.call,
          ),
        ),
      );

      expect(find.text(l10n.keepExistingTitle), findsOneWidget);
      expect(find.text(l10n.replaceWithNewTitle), findsOneWidget);
      expect(find.text(l10n.keepBothTitle), findsOneWidget);
    });
  });
}
