import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/app_theme.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:passvault/features/onboarding/presentation/intro_screen.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockOnboardingBloc extends Mock implements OnboardingBloc {
  @override
  Stream<OnboardingState> get stream => Stream.value(state);
}

void main() {
  late MockOnboardingBloc mockOnboardingBloc;

  setUp(() {
    mockOnboardingBloc = MockOnboardingBloc();
    when(() => mockOnboardingBloc.close()).thenAnswer((_) async {});
    when(() => mockOnboardingBloc.state).thenReturn(OnboardingInitial());
  });

  Widget createTestWidget() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: BlocProvider<OnboardingBloc>.value(
        value: mockOnboardingBloc,
        child: const IntroView(),
      ),
    );
  }

  group('$IntroScreen', () {
    testWidgets('PageView has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('intro_page_view')), findsOneWidget);
    });

    testWidgets('Skip button has correct key on first page', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('intro_skip_button')), findsOneWidget);
    });

    testWidgets('Next button has correct key', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('intro_next_button')), findsOneWidget);
    });

    testWidgets('Shows PageView widget', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('Tapping next moves to next page', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('intro_next_button')));
      await tester.pumpAndSettle();

      // Skip button should still be visible on second page
      expect(find.byKey(const Key('intro_skip_button')), findsOneWidget);
    });
  });
}
