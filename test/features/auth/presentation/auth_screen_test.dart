import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/app_theme.dart';
import 'package:passvault/features/auth/presentation/auth_screen.dart';
import 'package:passvault/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockAuthBloc extends Mock implements AuthBloc {
  @override
  Stream<AuthState> get stream => Stream.value(state);
}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.close()).thenAnswer((_) async {});
  });

  Widget createTestWidget(AuthState state) {
    when(() => mockAuthBloc.state).thenReturn(state);
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const AuthView(),
      ),
    );
  }

  group('$AuthScreen', () {
    testWidgets('Shows loading indicator with correct key', (tester) async {
      await tester.pumpWidget(createTestWidget(AuthLoading()));
      await tester.pump();

      expect(find.byKey(const Key('auth_loading')), findsOneWidget);
      expect(find.byType(AppLoader), findsOneWidget);
    });

    testWidgets('Loading indicator is AppLoader', (tester) async {
      await tester.pumpWidget(createTestWidget(AuthLoading()));
      await tester.pump();

      final indicator = tester.widget<AppLoader>(
        find.byKey(const Key('auth_loading')),
      );
      expect(indicator, isA<AppLoader>());
    });

    testWidgets('Shows AppButton when not loading', (tester) async {
      await tester.pumpWidget(createTestWidget(AuthInitial()));
      await tester.pump();

      expect(find.byType(AppButton), findsOneWidget);
      expect(find.byKey(const Key('auth_unlock_button')), findsOneWidget);
    });
  });
}
