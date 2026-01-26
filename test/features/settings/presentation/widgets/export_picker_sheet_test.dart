import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';
import 'package:passvault/features/settings/presentation/widgets/export_picker_sheet.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockImportExportBloc
    extends MockBloc<ImportExportEvent, ImportExportState>
    implements ImportExportBloc {}

void main() {
  late MockImportExportBloc mockBloc;

  setUp(() {
    mockBloc = MockImportExportBloc();
    when(() => mockBloc.state).thenReturn(const ImportExportInitial());
  });

  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('$ExportPickerSheet', () {
    testWidgets('selecting JSON export adds event to bloc', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithMaterial(ExportPickerSheet(bloc: mockBloc)),
      );

      await tester.tap(find.text('Export as JSON'));
      await tester.pumpAndSettle();

      verify(() => mockBloc.add(const ExportDataEvent(isJson: true))).called(1);
    });

    testWidgets('selecting CSV export adds event to bloc', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithMaterial(ExportPickerSheet(bloc: mockBloc)),
      );

      await tester.tap(find.text('Export as CSV'));
      await tester.pumpAndSettle();

      verify(
        () => mockBloc.add(const ExportDataEvent(isJson: false)),
      ).called(1);
    });
  });
}
