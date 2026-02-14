import 'package:bloc_test/bloc_test.dart';
import 'package:go_router/go_router.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_state.dart';
import 'package:passvault/features/password_manager/presentation/duplicate_resolution_screen.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../../robots/duplicate_resolution_robot.dart';

class MockImportExportBloc
    extends MockBloc<ImportExportEvent, ImportExportState>
    implements ImportExportBloc {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockImportExportBloc mockBloc;
  late MockGoRouter mockRouter;
  late DuplicateResolutionRobot robot;

  final testExisting = PasswordEntry(
    id: 'ent-1',
    appName: 'Google',
    username: 'user@gmail.com',
    password: 'old-password',
    lastUpdated: DateTime(2023),
  );

  final testNew = PasswordEntry(
    id: 'import-1',
    appName: 'Google',
    username: 'user@gmail.com',
    password: 'new-password',
    lastUpdated: DateTime(2024),
  );

  final testDuplicate = DuplicatePasswordEntry(
    existingEntry: testExisting,
    newEntry: testNew,
    conflictReason: 'Same appName and username',
  );

  setUp(() {
    mockBloc = MockImportExportBloc();
    mockRouter = MockGoRouter();
  });

  Future<void> loadScreen(
    WidgetTester tester,
    List<DuplicatePasswordEntry> duplicates, {
    bool usePumpAndSettle = true,
    ImportExportState? state,
  }) async {
    robot = DuplicateResolutionRobot(tester);
    when(() => mockBloc.state).thenReturn(
      state ?? DuplicatesDetected(duplicates: duplicates, successfulImports: 0),
    );

    await tester.pumpApp(
      InheritedGoRouter(
        goRouter: mockRouter,
        child: BlocProvider<ImportExportBloc>.value(
          value: mockBloc,
          child: const DuplicateResolutionScreen(),
        ),
      ),
      usePumpAndSettle: usePumpAndSettle,
    );
  }

  group('$DuplicateResolutionScreen', () {
    testWidgets('renders duplicates list accurately', (tester) async {
      when(() => mockBloc.state).thenReturn(const ImportExportInitial());
      final l10n = await getL10n();

      await loadScreen(tester, [testDuplicate]);

      expect(
        find.widgetWithText(AppBar, l10n.resolveDuplicatesTitle),
        findsOneWidget,
      );
      robot.expectTextVisible('Google');
      robot.expectTextVisible('user@gmail.com');
      robot.expectTextVisible(l10n.keepExistingTitle);
      robot.expectTextVisible(l10n.replaceWithNewTitle);
      robot.expectTextVisible(l10n.keepBothTitle);
    });

    testWidgets('Resolve All button is disabled initially', (tester) async {
      when(() => mockBloc.state).thenReturn(const ImportExportInitial());

      await loadScreen(tester, [testDuplicate]);

      robot.expectResolveButtonDisabled();
    });

    testWidgets('Resolve All button is enabled after choosing resolution', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const ImportExportInitial());
      final l10n = await getL10n();
      await loadScreen(tester, [testDuplicate]);

      await robot.tapChoice(l10n.keepExistingTitle);

      robot.expectResolveButtonEnabled();
    });

    testWidgets('shows success message and pops on resolution', (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          const ImportExportInitial(),
          const DuplicatesResolved(totalResolved: 1, totalImported: 1),
        ]),
        initialState: const ImportExportInitial(),
      );

      await loadScreen(tester, [testDuplicate]);
      await tester.pump();
      await tester.pumpAndSettle();

      verify(() => mockRouter.pop()).called(greaterThanOrEqualTo(1));
    });

    testWidgets('Bulk Action "Replace All" updates all duplicates', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final multipleDuplicates = [
        testDuplicate,
        testDuplicate.copyWith(
          existingEntry: testExisting.copyWith(
            id: 'ent-2',
            username: 'other@test.com',
          ),
          newEntry: testNew.copyWith(
            id: 'import-2',
            username: 'other@test.com',
          ),
        ),
      ];
      when(() => mockBloc.state).thenReturn(const ImportExportInitial());
      final l10n = await getL10n();
      await loadScreen(tester, multipleDuplicates);

      await robot.tapChoice(l10n.replaceAll);

      robot.expectChoiceSelected(DuplicateResolutionChoice.replaceWithNew, 2);
      robot.expectResolveButtonEnabled();
    });

    testWidgets('shows loading indicator when resolving', (tester) async {
      await loadScreen(
        tester,
        [testDuplicate],
        usePumpAndSettle: false,
        state: const ImportExportLoading(),
      );
      await tester.pump();

      robot.expectLoaderVisible();
      robot.expectResolveButtonLoading();
    });

    testWidgets('shows error SnackBar on failure', (tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          const ImportExportInitial(),
          const ImportExportFailure(DataMigrationError.unknown, 'Test Error'),
        ]),
        initialState: const ImportExportInitial(),
      );

      await loadScreen(tester, [testDuplicate]);
      await tester.pump();
      await tester.pumpAndSettle();

      robot.expectTextVisible('Test Error');
    });
  });
}
