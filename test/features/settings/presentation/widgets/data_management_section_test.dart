import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/widgets/data_management_section.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

class MockImportExportBloc
    extends MockBloc<ImportExportEvent, ImportExportState>
    implements ImportExportBloc {}

void main() {
  late MockSettingsBloc mockSettingsBloc;
  late MockImportExportBloc mockImportExportBloc;

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
    mockImportExportBloc = MockImportExportBloc();
    when(() => mockSettingsBloc.state).thenReturn(const SettingsInitial());
    when(
      () => mockImportExportBloc.state,
    ).thenReturn(const ImportExportInitial());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
            BlocProvider<ImportExportBloc>.value(value: mockImportExportBloc),
          ],
          child: const DataManagementSection(),
        ),
      ),
    );
  }

  group('$DataManagementSection', () {
    testWidgets('displays import and export tiles', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Export Data (JSON/CSV)'), findsOneWidget);
      expect(find.text('Import Data'), findsOneWidget);
    });

    testWidgets('tapping export tile shows export picker sheet', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Export Data (JSON/CSV)'));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
    });

    testWidgets('tapping import tile shows import picker sheet', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Import Data'));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
    });
  });
}
