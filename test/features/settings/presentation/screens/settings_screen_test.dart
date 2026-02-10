import 'package:go_router/go_router.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/features/home/presentation/bloc/password_bloc.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:passvault/features/settings/presentation/settings_screen.dart';

import '../../../../fixtures/settings_fixtures.dart';
import '../../../../helpers/test_helpers.dart';
import '../../../../robots/settings_robot.dart';

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
  late SettingsRobot robot;

  setUpAll(() async {
    registerFallbackValue(const ResetMigrationStatus());
    l10n = await getL10n();
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
      SettingsLoaded(
        useBiometrics: false,
        passwordSettings: SettingsFixtures.initialSettings,
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

  Future<void> loadSettingsScreen(WidgetTester tester) async {
    robot = SettingsRobot(tester);
    await tester.pumpApp(
      InheritedGoRouter(
        goRouter: mockGoRouter,
        child: MultiBlocProvider(
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
    testWidgets('Tapping Export JSON dispatches correct event', (tester) async {
      await loadSettingsScreen(tester);

      await robot.tapExport();
      await robot.tapExportJson();

      verify(
        () => mockImportExportBloc.add(const ExportDataEvent(isJson: true)),
      ).called(1);
    });

    testWidgets('Shows success message on ExportSuccess', (tester) async {
      when(
        () => mockImportExportBloc.state,
      ).thenReturn(const ExportSuccess('/path/to/file'));
      await loadSettingsScreen(tester);

      robot.expectSnackBarContaining(l10n.exportSuccess);
      verify(
        () => mockImportExportBloc.add(const ResetMigrationStatus()),
      ).called(1);
    });

    testWidgets('Shows success message on ImportSuccess', (tester) async {
      when(() => mockImportExportBloc.state).thenReturn(const ImportSuccess(5));
      await loadSettingsScreen(tester);

      robot.expectSnackBarContaining(l10n.importSuccess);
      verify(
        () => mockImportExportBloc.add(const ResetMigrationStatus()),
      ).called(1);
    });

    testWidgets('Navigates to resolution screen on DuplicatesDetected', (
      tester,
    ) async {
      final mockDuplicate = MockDuplicatePasswordEntry();
      when(() => mockImportExportBloc.state).thenReturn(
        DuplicatesDetected(duplicates: [mockDuplicate], successfulImports: 0),
      );
      when(
        () => mockGoRouter.push(any(), extra: any(named: 'extra')),
      ).thenAnswer((_) async => null);

      await loadSettingsScreen(tester);

      verify(
        () => mockGoRouter.push(
          AppRoutes.resolveDuplicates,
          extra: any(named: 'extra'),
        ),
      ).called(1);
      verify(
        () => mockImportExportBloc.add(const ResetMigrationStatus()),
      ).called(1);
    });

    testWidgets('Shows success message on ClearDatabaseSuccess', (
      tester,
    ) async {
      when(
        () => mockImportExportBloc.state,
      ).thenReturn(const ClearDatabaseSuccess());
      await loadSettingsScreen(tester);

      robot.expectSnackBarContaining(l10n.databaseCleared);
      verify(
        () => mockImportExportBloc.add(const ResetMigrationStatus()),
      ).called(1);
    });

    testWidgets('Shows snackbar on ImportExportFailure', (tester) async {
      when(() => mockImportExportBloc.state).thenReturn(
        const ImportExportFailure(
          DataMigrationError.wrongPassword,
          'Error message',
        ),
      );
      await loadSettingsScreen(tester);

      expect(find.byType(SnackBar), findsOneWidget);
      verify(
        () => mockImportExportBloc.add(const ResetMigrationStatus()),
      ).called(1);
    });
  });
}
