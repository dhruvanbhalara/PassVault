import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:passvault/features/settings/presentation/widgets/appearance_section.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockThemeBloc extends MockBloc<ThemeEvent, ThemeState>
    implements ThemeBloc {}

void main() {
  late MockThemeBloc mockThemeBloc;

  setUpAll(() {
    registerFallbackValue(ThemeType.system);
  });

  setUp(() {
    mockThemeBloc = MockThemeBloc();
    when(() => mockThemeBloc.state).thenReturn(
      const ThemeState(
        themeType: ThemeType.system,
        themeMode: ThemeMode.system,
      ),
    );
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider<ThemeBloc>.value(
          value: mockThemeBloc,
          child: const AppearanceSection(),
        ),
      ),
    );
  }

  group('$AppearanceSection', () {
    testWidgets('displays theme tile with current theme name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('System Default'), findsOneWidget);
    });

    testWidgets('tapping theme tile shows theme picker sheet', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('settings_theme_tile')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('theme_option_light')), findsOneWidget);
      expect(find.byKey(const Key('theme_option_dark')), findsOneWidget);
      expect(find.byKey(const Key('theme_option_amoled')), findsOneWidget);
    });

    testWidgets('selecting a theme calls cubit and closes sheet', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('settings_theme_tile')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('theme_option_light')));
      await tester.pumpAndSettle();

      verify(
        () => mockThemeBloc.add(const ThemeChanged(ThemeType.light)),
      ).called(1);
      expect(find.byKey(const Key('theme_option_light')), findsNothing);
    });
  });
}
