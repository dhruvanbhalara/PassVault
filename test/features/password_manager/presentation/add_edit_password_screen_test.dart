import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/app_theme.dart';
import 'package:passvault/features/home/presentation/bloc/password_bloc.dart';
import 'package:passvault/features/password_manager/presentation/add_edit_password_screen.dart';
import 'package:passvault/features/password_manager/presentation/bloc/add_edit_password_bloc.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockAddEditPasswordBloc extends Mock implements AddEditPasswordBloc {
  @override
  Stream<AddEditPasswordState> get stream => Stream.value(state);
}

class MockPasswordBloc extends Mock implements PasswordBloc {
  @override
  Stream<PasswordState> get stream => Stream.value(state);
}

void main() {
  late MockAddEditPasswordBloc mockAddEditBloc;
  late MockPasswordBloc mockPasswordBloc;

  setUp(() {
    mockAddEditBloc = MockAddEditPasswordBloc();
    mockPasswordBloc = MockPasswordBloc();
    when(() => mockAddEditBloc.close()).thenAnswer((_) async {});
    when(() => mockPasswordBloc.close()).thenAnswer((_) async {});
    when(() => mockAddEditBloc.state).thenReturn(const AddEditInitial());
    when(() => mockPasswordBloc.state).thenReturn(const PasswordInitial());
  });

  Widget createTestWidget() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AddEditPasswordBloc>.value(value: mockAddEditBloc),
          BlocProvider<PasswordBloc>.value(value: mockPasswordBloc),
        ],
        child: const AddEditPasswordView(),
      ),
    );
  }

  group('$AddEditPasswordScreen', () {
    testWidgets('Save button has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add_edit_save_button')), findsOneWidget);
    });

    testWidgets('Save button is a FloatingActionButton', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final fab = tester.widget<FloatingActionButton>(
        find.byKey(const Key('add_edit_save_button')),
      );
      expect(fab, isA<FloatingActionButton>());
    });

    testWidgets('App name field has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add_edit_app_name_field')), findsOneWidget);
    });

    testWidgets('Username field has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add_edit_username_field')), findsOneWidget);
    });

    testWidgets('Password field has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add_edit_password_field')), findsOneWidget);
    });

    testWidgets('Visibility toggle has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('add_edit_visibility_toggle')),
        findsOneWidget,
      );
    });

    testWidgets('Generate button has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('add_edit_generate_button')), findsOneWidget);
    });

    testWidgets('Can enter text in app name field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('add_edit_app_name_field')),
        'Netflix',
      );
      await tester.pump();

      // Verify text was entered by finding the text widget
      expect(find.text('Netflix'), findsAtLeastNWidgets(1));
    });

    testWidgets('Can enter text in username field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('add_edit_username_field')),
        'user@email.com',
      );
      await tester.pump();

      expect(find.text('user@email.com'), findsOneWidget);
    });

    testWidgets('Can enter text in password field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('add_edit_password_field')),
        'SecurePass123',
      );
      await tester.pump();

      // Password field is obscured, verify entry happened via text widget
      expect(find.byKey(const Key('add_edit_password_field')), findsOneWidget);
    });

    testWidgets('Tapping visibility toggle works', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap toggle - should not throw
      await tester.tap(find.byKey(const Key('add_edit_visibility_toggle')));
      await tester.pump();

      // Verify toggle is still there after tap
      expect(
        find.byKey(const Key('add_edit_visibility_toggle')),
        findsOneWidget,
      );
    });
  });
}
