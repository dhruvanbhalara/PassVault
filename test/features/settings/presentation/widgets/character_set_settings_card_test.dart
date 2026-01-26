import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/widgets/character_set_settings_card.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

void main() {
  late MockSettingsBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(LoadSettings());
  });

  setUp(() {
    mockBloc = MockSettingsBloc();
    when(() => mockBloc.state).thenReturn(const SettingsState());
  });

  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider<SettingsBloc>.value(value: mockBloc, child: child),
      ),
    );
  }

  group('$CharacterSetSettingsCard', () {
    testWidgets('renders all toggles correctly', (WidgetTester tester) async {
      const settings = PasswordGenerationSettings(
        useUppercase: true,
        useLowercase: false,
        useNumbers: true,
        useSpecialChars: false,
        excludeAmbiguousChars: true,
      );

      await tester.pumpWidget(
        wrapWithMaterial(const CharacterSetSettingsCard(settings: settings)),
      );

      expect(find.text('Uppercase'), findsOneWidget);
      expect(find.text('Lowercase'), findsOneWidget);
      expect(find.text('Numbers'), findsOneWidget);
      expect(find.text('Special Characters'), findsOneWidget);
      expect(find.text('Exclude Ambiguous'), findsOneWidget);

      final switches = find.byType(Switch);
      expect(tester.widget<Switch>(switches.at(0)).value, isTrue); // Uppercase
      expect(tester.widget<Switch>(switches.at(1)).value, isFalse); // Lowercase
      expect(tester.widget<Switch>(switches.at(2)).value, isTrue); // Numbers
      expect(tester.widget<Switch>(switches.at(3)).value, isFalse); // Special
      expect(tester.widget<Switch>(switches.at(4)).value, isTrue); // Ambiguous
    });

    testWidgets('adds UpdatePasswordSettings event when toggled', (
      WidgetTester tester,
    ) async {
      const settings = PasswordGenerationSettings();

      await tester.pumpWidget(
        wrapWithMaterial(const CharacterSetSettingsCard(settings: settings)),
      );

      await tester.tap(find.text('Uppercase'));
      await tester.pumpAndSettle();

      verify(
        () => mockBloc.add(any(that: isA<UpdatePasswordSettings>())),
      ).called(1);
    });
  });
}
