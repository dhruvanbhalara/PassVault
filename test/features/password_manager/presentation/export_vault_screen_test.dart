import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';
import 'package:passvault/features/password_manager/presentation/export_vault_screen.dart';

import '../../../helpers/test_helpers.dart';
import '../../../robots/export_vault_robot.dart';

class MockImportExportBloc extends Mock implements ImportExportBloc {
  @override
  Stream<ImportExportState> get stream => Stream.value(state);
}

void main() {
  late MockImportExportBloc mockImportExportBloc;
  late AppLocalizations l10n;
  late ExportVaultRobot robot;

  setUpAll(() async {
    registerFallbackValue(const ResetMigrationStatus());
    l10n = await getL10n();
  });

  setUp(() {
    mockImportExportBloc = MockImportExportBloc();
    when(() => mockImportExportBloc.close()).thenAnswer((_) async {});
    when(
      () => mockImportExportBloc.state,
    ).thenReturn(const ImportExportInitial());
  });

  Future<void> loadExportVaultScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    robot = ExportVaultRobot(tester);
    await tester.pumpApp(
      BlocProvider<ImportExportBloc>.value(
        value: mockImportExportBloc,
        child: const ExportVaultScreen(),
      ),
    );
  }

  group('$ExportVaultScreen', () {
    testWidgets('Initial state has JSON selected and encryption enabled', (
      tester,
    ) async {
      await loadExportVaultScreen(tester);

      robot.expectPasswordFieldVisible(true);
    });

    testWidgets('Toggles encryption visibility', (tester) async {
      await loadExportVaultScreen(tester);

      await robot.toggleEncryption(false);
      robot.expectPasswordFieldVisible(false);

      await robot.toggleEncryption(true);
      robot.expectPasswordFieldVisible(true);
    });

    testWidgets('Exports JSON unencrypted when encryption disabled', (
      tester,
    ) async {
      await loadExportVaultScreen(tester);

      await robot.selectJsonFormat();
      await robot.toggleEncryption(false);
      await robot.tapExport();

      verify(
        () => mockImportExportBloc.add(const ExportDataEvent(isJson: true)),
      ).called(1);
    });

    testWidgets('Exports CSV unencrypted', (tester) async {
      await loadExportVaultScreen(tester);

      await robot.selectCsvFormat();
      await robot.toggleEncryption(false);
      await robot.tapExport();

      verify(
        () => mockImportExportBloc.add(const ExportDataEvent(isJson: false)),
      ).called(1);
    });

    testWidgets('Exports Encrypted with password', (tester) async {
      await loadExportVaultScreen(tester);

      await robot.toggleEncryption(true);
      await robot.enterPassword('secret');
      await robot.tapExport();

      verify(
        () => mockImportExportBloc.add(const ExportEncryptedEvent('secret')),
      ).called(1);
    });

    testWidgets('Shows error if password empty when encryption enabled', (
      tester,
    ) async {
      await loadExportVaultScreen(tester);

      await robot.toggleEncryption(true);
      await robot.tapExport();

      robot.expectSnackBarContaining(l10n.passwordRequired);
      verifyNever(() => mockImportExportBloc.add(any()));
    });

    testWidgets('Shows success message on ExportSuccess and resets status', (
      tester,
    ) async {
      when(
        () => mockImportExportBloc.state,
      ).thenReturn(const ExportSuccess('/path/to/file'));
      await loadExportVaultScreen(tester);

      robot.expectSnackBarContaining(l10n.exportSuccess);
      verify(
        () => mockImportExportBloc.add(const ResetMigrationStatus()),
      ).called(1);
    });

    testWidgets('Shows error message on ImportExportFailure', (tester) async {
      when(() => mockImportExportBloc.state).thenReturn(
        const ImportExportFailure(
          DataMigrationError.unknown,
          'Test Error Message',
        ),
      );
      await loadExportVaultScreen(tester);

      robot.expectSnackBarContaining('Test Error Message');
      verify(
        () => mockImportExportBloc.add(const ResetMigrationStatus()),
      ).called(1);
    });
  });
}
