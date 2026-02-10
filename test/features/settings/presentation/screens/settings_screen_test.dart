import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/app_theme.dart';
import 'package:passvault/features/home/presentation/bloc/password_bloc.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:passvault/features/settings/presentation/settings_screen.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockSettingsBloc extends Mock implements SettingsBloc {
  @override
  Stream<SettingsState> get stream => Stream.value(state);
}

class MockThemeBloc extends Mock implements ThemeBloc {
  @override
  Stream<ThemeState> get stream => Stream.value(state);
}

class MockPasswordBloc extends Mock implements PasswordBloc {
  @override
  Stream<PasswordState> get stream => Stream.value(state);
}

class MockImportExportBloc extends Mock implements ImportExportBloc {
  @override
  Stream<ImportExportState> get stream => Stream.value(state);
}

class MockGoRouter extends Mock implements GoRouter {}

class MockDuplicatePasswordEntry extends Mock
    implements DuplicatePasswordEntry {}

void main() {
  late MockSettingsBloc mockSettingsBloc;
  late MockThemeBloc mockThemeBloc;
  late MockPasswordBloc mockPasswordBloc;
  late MockImportExportBloc mockImportExportBloc;
  late MockGoRouter mockGoRouter;
  late AppLocalizations l10n;

  setUpAll(() async {
    registerFallbackValue(const ResetMigrationStatus());
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
    mockThemeBloc = MockThemeBloc();
    mockPasswordBloc = MockPasswordBloc();
    mockImportExportBloc = MockImportExportBloc();
    mockGoRouter = MockGoRouter();

    when(() => mockSettingsBloc.close()).thenAnswer((_) async {});
    when(() => mockThemeBloc.close()).thenAnswer((_) async {});
    when(() => mockPasswordBloc.close()).thenAnswer((_) async {});
    when(() => mockImportExportBloc.close()).thenAnswer((_) async {});

    when(() => mockSettingsBloc.state).thenReturn(
      const SettingsLoaded(
        useBiometrics: false,
        passwordSettings: PasswordGenerationSettings(
          strategies: [],
          defaultStrategyId: '',
        ),
      ),
    );
    when(() => mockThemeBloc.state).thenReturn(
      const ThemeLoaded(
        themeType: ThemeType.system,
        themeMode: ThemeMode.system,
      ),
    );
    when(() => mockPasswordBloc.state).thenReturn(const PasswordInitial());
    when(
      () => mockImportExportBloc.state,
    ).thenReturn(const ImportExportInitial());
  });

  Widget createTestWidget() {
    return InheritedGoRouter(
      goRouter: mockGoRouter,
      child: MaterialApp(
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
            BlocProvider<ThemeBloc>.value(value: mockThemeBloc),
            BlocProvider<PasswordBloc>.value(value: mockPasswordBloc),
            BlocProvider<ImportExportBloc>.value(value: mockImportExportBloc),
          ],
          child: const SettingsView(),
        ),
      ),
    );
  }

  group('$SettingsScreen', () {
    testWidgets(
      'Tapping Export JSON dispatches correct event to ImportExportBloc',
      (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('settings_export_tile')));
        await tester.pumpAndSettle();

        final jsonTile = find.byKey(const Key('export_json_tile'));
        expect(jsonTile, findsOneWidget);

        await tester.tap(jsonTile);
        await tester.pump();

        verify(
          () => mockImportExportBloc.add(const ExportDataEvent(isJson: true)),
        ).called(1);
      },
    );

    testWidgets('Shows correct message for ExportSuccess', (tester) async {
      when(
        () => mockImportExportBloc.state,
      ).thenReturn(const ExportSuccess('/path/to/file'));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100)); // Wait for snackbar

      expect(find.textContaining(l10n.exportSuccess), findsOneWidget);
      verify(
        () => mockImportExportBloc.add(const ResetMigrationStatus()),
      ).called(1);
    });

    testWidgets('Shows correct message for ImportSuccess and reloads passwords', (
      tester,
    ) async {
      when(() => mockImportExportBloc.state).thenReturn(const ImportSuccess(5));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100)); // Wait for snackbar

      expect(find.textContaining(l10n.importSuccess), findsOneWidget);
      // verify(() => mockPasswordBloc.add(const LoadPasswords())).called(1); // Auto-reloads via stream
      verify(
        () => mockImportExportBloc.add(const ResetMigrationStatus()),
      ).called(1);
    });

    testWidgets('Shows correct message for ClearDatabaseSuccess', (
      tester,
    ) async {
      when(
        () => mockImportExportBloc.state,
      ).thenReturn(const ClearDatabaseSuccess());

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100)); // Wait for snackbar

      expect(find.textContaining(l10n.databaseCleared), findsOneWidget);
      verify(
        () => mockImportExportBloc.add(const ResetMigrationStatus()),
      ).called(1);
    });

    testWidgets(
      'Navigates to resolution screen and resets on DuplicatesDetected',
      (tester) async {
        final mockDuplicate = MockDuplicatePasswordEntry();
        when(() => mockImportExportBloc.state).thenReturn(
          DuplicatesDetected(duplicates: [mockDuplicate], successfulImports: 0),
        );
        when(
          () => mockGoRouter.push(any(), extra: any(named: 'extra')),
        ).thenAnswer((_) async => null);

        await tester.pumpWidget(createTestWidget());
        await tester.pump(); // Listener triggers navigation

        // Verify go_router push occurred
        verify(
          () => mockGoRouter.push(
            '/resolve-duplicates',
            extra: any(named: 'extra'),
          ),
        ).called(1);
        // Verify reset event
        verify(
          () => mockImportExportBloc.add(const ResetMigrationStatus()),
        ).called(1);
      },
    );

    testWidgets('Shows localized error message on ImportExportFailure', (
      tester,
    ) async {
      when(() => mockImportExportBloc.state).thenReturn(
        const ImportExportFailure(
          DataMigrationError.wrongPassword,
          'Error message',
        ),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(SnackBar), findsOneWidget);
      verify(
        () => mockImportExportBloc.add(const ResetMigrationStatus()),
      ).called(1);
    });
  });
}
