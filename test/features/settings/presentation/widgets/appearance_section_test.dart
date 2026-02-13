import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:passvault/features/settings/presentation/widgets/appearance_section.dart';

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
      const ThemeLoaded(
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
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(l10n.theme), findsOneWidget);
      expect(find.text(l10n.system), findsOneWidget);
    });

    testWidgets('displays palette icon and chevron on theme tile', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(LucideIcons.palette), findsOneWidget);
      expect(find.byIcon(LucideIcons.chevronRight), findsOneWidget);
    });

    testWidgets('shows AMOLED subtitle when amoled theme is active', (
      WidgetTester tester,
    ) async {
      when(() => mockThemeBloc.state).thenReturn(
        const ThemeLoaded(
          themeType: ThemeType.amoled,
          themeMode: ThemeMode.dark,
        ),
      );
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text(l10n.amoled), findsOneWidget);
    });

    testWidgets('tapping theme tile shows theme picker sheet', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('settings_theme_tile')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('theme_option_system')), findsOneWidget);
      expect(find.byKey(const Key('theme_option_light')), findsOneWidget);
      expect(find.byKey(const Key('theme_option_dark')), findsOneWidget);
      expect(find.byKey(const Key('theme_option_amoled')), findsOneWidget);
    });

    testWidgets('theme picker shows checkmark on current selection', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('settings_theme_tile')));
      await tester.pumpAndSettle();

      // System is the current theme, so check icon should appear
      expect(find.byIcon(LucideIcons.check), findsOneWidget);
    });

    testWidgets('selecting a theme calls bloc and closes sheet', (
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

    testWidgets('selecting AMOLED theme dispatches correct event', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('settings_theme_tile')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('theme_option_amoled')));
      await tester.pumpAndSettle();

      verify(
        () => mockThemeBloc.add(const ThemeChanged(ThemeType.amoled)),
      ).called(1);
      expect(find.byKey(const Key('theme_option_amoled')), findsNothing);
    });
  });
}
