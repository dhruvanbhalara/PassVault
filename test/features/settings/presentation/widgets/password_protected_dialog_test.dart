import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';
import 'package:passvault/features/settings/presentation/widgets/password_protected_dialog.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockImportExportBloc
    extends MockBloc<ImportExportEvent, ImportExportState>
    implements ImportExportBloc {}

void main() {
  late MockImportExportBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(const ImportDataEvent(isJson: true));
  });

  setUp(() {
    mockBloc = MockImportExportBloc();
    when(() => mockBloc.state).thenReturn(const ImportExportInitial());
  });

  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }

  group('$PasswordProtectedDialog', () {
    testWidgets('renders correctly with export title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          PasswordProtectedDialog(bloc: mockBloc, isExport: true),
        ),
      );

      expect(find.text('Export Encrypted (.pvault)'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('shows error when password is empty on submit', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          PasswordProtectedDialog(bloc: mockBloc, isExport: true),
        ),
      );

      await tester.tap(find.text('Export'));
      await tester.pumpAndSettle();

      expect(find.text('Password is required'), findsOneWidget);
      verifyNever(() => mockBloc.add(any()));
    });

    testWidgets('adds ExportEncryptedEvent on valid submit', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        wrapWithMaterial(
          PasswordProtectedDialog(bloc: mockBloc, isExport: true),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'secret123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Export'));
      await tester.pumpAndSettle();

      verify(
        () => mockBloc.add(const ExportEncryptedEvent('secret123')),
      ).called(1);
    });
  });
}
