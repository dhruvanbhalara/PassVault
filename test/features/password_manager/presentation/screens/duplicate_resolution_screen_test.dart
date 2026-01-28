import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/app_theme.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';
import 'package:passvault/features/password_manager/presentation/duplicate_resolution_screen.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockImportExportBloc
    extends MockBloc<ImportExportEvent, ImportExportState>
    implements ImportExportBloc {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockImportExportBloc mockBloc;
  late MockGoRouter mockRouter;

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

  Widget createTestWidget(List<DuplicatePasswordEntry> duplicates) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: InheritedGoRouter(
        goRouter: mockRouter,
        child: BlocProvider<ImportExportBloc>.value(
          value: mockBloc,
          child: DuplicateResolutionView(duplicates: duplicates),
        ),
      ),
    );
  }

  group('$DuplicateResolutionScreen', () {
    testWidgets('renders duplicates list accurately', (tester) async {
      when(() => mockBloc.state).thenReturn(const ImportExportInitial());

      await tester.pumpWidget(createTestWidget([testDuplicate]));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Resolve Duplicates'), findsOneWidget);
      expect(find.text('Google'), findsWidgets);
      expect(find.text('Username: user@gmail.com'), findsWidgets);
      expect(find.text('Keep Existing'), findsOneWidget);
      expect(find.text('Replace with New'), findsOneWidget);
      expect(find.text('Keep Both'), findsOneWidget);
    });

    testWidgets('Resolve All button is disabled initially', (tester) async {
      when(() => mockBloc.state).thenReturn(const ImportExportInitial());

      await tester.pumpWidget(createTestWidget([testDuplicate]));
      await tester.pumpAndSettle();

      final button = tester.widget<AppButton>(
        find.byKey(const Key('resolve_duplicates_button')),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('Resolve All button is enabled after choosing resolution', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(const ImportExportInitial());

      await tester.pumpWidget(createTestWidget([testDuplicate]));
      await tester.pumpAndSettle();

      // Tap "Keep Existing"
      await tester.tap(find.text('Keep Existing'));
      await tester.pumpAndSettle();

      final button = tester.widget<AppButton>(
        find.byKey(const Key('resolve_duplicates_button')),
      );
      expect(button.onPressed, isNotNull);
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

      await tester.pumpWidget(createTestWidget([testDuplicate]));
      await tester.pump();
      await tester.pumpAndSettle();

      // Snack bar is now in SettingsScreen, so we just check for pop
      verify(() => mockRouter.pop()).called(greaterThanOrEqualTo(1));
    });

    testWidgets('Bulk Action "Replace All" updates all duplicates', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(
        1200,
        2400,
      ); // Ensures all items fit
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

      await tester.pumpWidget(createTestWidget(multipleDuplicates));
      await tester.pumpAndSettle();

      // Initially button is disabled
      var button = tester.widget<AppButton>(
        find.byKey(const Key('resolve_duplicates_button')),
      );
      expect(button.onPressed, isNull);

      // Tap "Replace All" in Bulk Actions
      await tester.tap(find.text('Replace All'));
      await tester.pumpAndSettle();

      // Check if both duplicate cards now show "Replace with New" as selected
      // We find all RadioListTiles and filter those with the target value
      final replaceRadios = find.byWidgetPredicate(
        (widget) =>
            widget is RadioListTile<DuplicateResolutionChoice> &&
            widget.value == DuplicateResolutionChoice.replaceWithNew,
      );
      expect(replaceRadios, findsNWidgets(2));

      for (final radioFinder in replaceRadios.evaluate()) {
        final radioGroup = tester.widget<RadioGroup<DuplicateResolutionChoice>>(
          find
              .ancestor(
                of: find.byWidget(radioFinder.widget),
                matching: find.byType(RadioGroup<DuplicateResolutionChoice>),
              )
              .first,
        );
        expect(radioGroup.groupValue, DuplicateResolutionChoice.replaceWithNew);
      }

      // Final resolution button should now be enabled
      button = tester.widget<AppButton>(
        find.byKey(const Key('resolve_duplicates_button')),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('shows loading indicator when resolving', (tester) async {
      when(() => mockBloc.state).thenReturn(const ImportExportLoading());

      await tester.pumpWidget(createTestWidget([testDuplicate]));
      await tester.pump(); // Allow build

      expect(find.byType(AppLoader), findsOneWidget);
      expect(
        tester
            .widget<AppButton>(
              find.byKey(const Key('resolve_duplicates_button')),
            )
            .isLoading,
        isTrue,
      );
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

      await tester.pumpWidget(createTestWidget([testDuplicate]));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Test Error'), findsOneWidget);
      expect(
        find.byIcon(LucideIcons.circleCheck),
        findsOneWidget,
      ); // Button reset
    });
  });
}
