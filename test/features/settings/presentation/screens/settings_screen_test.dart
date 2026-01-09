import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/app_theme.dart';
import 'package:passvault/features/home/presentation/bloc/password_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_cubit.dart';
import 'package:passvault/features/settings/presentation/settings_screen.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockSettingsBloc extends Mock implements SettingsBloc {
  @override
  Stream<SettingsState> get stream => Stream.value(state);
}

class MockThemeCubit extends Mock implements ThemeCubit {
  @override
  Stream<ThemeState> get stream => Stream.value(state);
}

class MockPasswordBloc extends Mock implements PasswordBloc {
  @override
  Stream<PasswordState> get stream => Stream.value(state);
}

void main() {
  late MockSettingsBloc mockSettingsBloc;
  late MockThemeCubit mockThemeCubit;
  late MockPasswordBloc mockPasswordBloc;

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
    mockThemeCubit = MockThemeCubit();
    mockPasswordBloc = MockPasswordBloc();

    when(() => mockSettingsBloc.close()).thenAnswer((_) async {});
    when(() => mockThemeCubit.close()).thenAnswer((_) async {});
    when(() => mockPasswordBloc.close()).thenAnswer((_) async {});

    when(() => mockSettingsBloc.state).thenReturn(
      const SettingsState(status: SettingsStatus.initial, useBiometrics: false),
    );
    when(() => mockThemeCubit.state).thenReturn(
      const ThemeState(
        themeType: ThemeType.system,
        themeMode: ThemeMode.system,
      ),
    );
    when(() => mockPasswordBloc.state).thenReturn(PasswordInitial());
  });

  Widget createTestWidget() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
          BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
          BlocProvider<PasswordBloc>.value(value: mockPasswordBloc),
        ],
        child: const SettingsView(),
      ),
    );
  }

  group('SettingsScreen Widget Tests with Keys', () {
    testWidgets('Theme tile has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('settings_theme_tile')), findsOneWidget);
    });

    testWidgets('Password generation tile has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('settings_password_gen_tile')),
        findsOneWidget,
      );
    });

    testWidgets('Biometric switch has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('settings_biometric_switch')),
        findsOneWidget,
      );
    });

    testWidgets('Export tile has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('settings_export_tile')), findsOneWidget);
    });

    testWidgets('Import tile has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('settings_import_tile')), findsOneWidget);
    });

    testWidgets('Biometric switch shows correct value when off', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final switchTile = tester.widget<SwitchListTile>(
        find.byKey(const Key('settings_biometric_switch')),
      );
      expect(switchTile.value, isFalse);
    });

    testWidgets('Biometric switch shows correct value when on', (tester) async {
      when(() => mockSettingsBloc.state).thenReturn(
        const SettingsState(
          status: SettingsStatus.initial,
          useBiometrics: true,
        ),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final switchTile = tester.widget<SwitchListTile>(
        find.byKey(const Key('settings_biometric_switch')),
      );
      expect(switchTile.value, isTrue);
    });

    testWidgets('Tapping theme tile works', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('settings_theme_tile')));
      await tester.pumpAndSettle();

      // Theme picker should appear (bottom sheet)
      expect(find.byType(BottomSheet), findsOneWidget);
    });
  });
}
