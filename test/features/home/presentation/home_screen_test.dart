import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/app_theme.dart';
import 'package:passvault/features/home/presentation/bloc/password_bloc.dart';
import 'package:passvault/features/home/presentation/home_screen.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockPasswordBloc extends Mock implements PasswordBloc {
  @override
  Stream<PasswordState> get stream => Stream.value(state);
}

void main() {
  late MockPasswordBloc mockPasswordBloc;

  final testPasswords = [
    PasswordEntry(
      id: 'id-1',
      appName: 'Google',
      username: 'user@gmail.com',
      password: 'password123',
      lastUpdated: DateTime(2024, 1, 1),
    ),
    PasswordEntry(
      id: 'id-2',
      appName: 'Facebook',
      username: 'user@fb.com',
      password: 'fbpass456',
      lastUpdated: DateTime(2024, 1, 2),
    ),
  ];

  setUp(() {
    mockPasswordBloc = MockPasswordBloc();
    when(() => mockPasswordBloc.close()).thenAnswer((_) async {});
  });

  Widget createTestWidget(PasswordState state) {
    when(() => mockPasswordBloc.state).thenReturn(state);
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: BlocProvider<PasswordBloc>.value(
        value: mockPasswordBloc,
        child: const HomeView(),
      ),
    );
  }

  group('$HomeScreen', () {
    testWidgets('FAB has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget(const PasswordLoaded([])));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_fab')), findsOneWidget);
    });

    testWidgets('Settings button has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget(const PasswordLoaded([])));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_settings_button')), findsOneWidget);
    });

    testWidgets('Shows loading indicator with correct key', (tester) async {
      await tester.pumpWidget(createTestWidget(const PasswordLoading()));

      expect(find.byKey(const Key('home_loading')), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Shows empty state text with correct key', (tester) async {
      await tester.pumpWidget(createTestWidget(const PasswordLoaded([])));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_empty_text')), findsOneWidget);
    });

    testWidgets('Shows password list with correct key when loaded', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(PasswordLoaded(testPasswords)));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_password_list')), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Facebook'), findsOneWidget);
    });

    testWidgets('Password list shows all entries', (tester) async {
      await tester.pumpWidget(createTestWidget(PasswordLoaded(testPasswords)));
      await tester.pumpAndSettle();

      expect(find.text('user@gmail.com'), findsOneWidget);
      expect(find.text('user@fb.com'), findsOneWidget);
    });

    testWidgets('FAB is a FloatingActionButton', (tester) async {
      await tester.pumpWidget(createTestWidget(const PasswordLoaded([])));
      await tester.pumpAndSettle();

      final fab = tester.widget<FloatingActionButton>(
        find.byKey(const Key('home_fab')),
      );
      expect(fab, isA<FloatingActionButton>());
    });
  });
}
