import 'package:bloc_test/bloc_test.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';
import 'package:passvault/features/settings/presentation/widgets/password_protected_dialog.dart';

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

  group('$PasswordProtectedDialog', () {
    testWidgets('submitting password adds ExportEncryptedData event', (
      WidgetTester tester,
    ) async {
      final l10n = await getL10n();
      await tester.pumpApp(
        PasswordProtectedDialog(bloc: mockBloc, isExport: true),
      );

      await tester.enterText(find.byType(TextFormField), 'password123');
      await tester.tap(find.text(l10n.export));
      await tester.pumpAndSettle();

      verify(
        () => mockBloc.add(const ExportEncryptedEvent('password123')),
      ).called(1);
    });
  });
}
