import 'package:bloc_test/bloc_test.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';
import 'package:passvault/features/settings/presentation/widgets/export_picker_sheet.dart';

import '../../../../helpers/test_helpers.dart';

class MockImportExportBloc
    extends MockBloc<ImportExportEvent, ImportExportState>
    implements ImportExportBloc {}

void main() {
  late MockImportExportBloc mockBloc;

  setUp(() {
    mockBloc = MockImportExportBloc();
    when(() => mockBloc.state).thenReturn(const ImportExportInitial());
  });

  group('$ExportPickerSheet', () {
    testWidgets('selecting JSON export adds event to bloc', (
      WidgetTester tester,
    ) async {
      final l10n = await getL10n();
      await tester.pumpApp(ExportPickerSheet(bloc: mockBloc));

      await tester.tap(find.text(l10n.exportJson));
      await tester.pumpAndSettle();

      verify(() => mockBloc.add(const ExportDataEvent(isJson: true))).called(1);
    });

    testWidgets('selecting CSV export adds event to bloc', (
      WidgetTester tester,
    ) async {
      final l10n = await getL10n();
      await tester.pumpApp(ExportPickerSheet(bloc: mockBloc));

      await tester.tap(find.text(l10n.exportCsv));
      await tester.pumpAndSettle();

      verify(
        () => mockBloc.add(const ExportDataEvent(isJson: false)),
      ).called(1);
    });
  });
}
