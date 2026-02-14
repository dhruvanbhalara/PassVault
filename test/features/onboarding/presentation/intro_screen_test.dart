import 'dart:async';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding/onboarding_bloc.dart';
import 'package:passvault/features/onboarding/presentation/intro_screen.dart';

import '../../../helpers/test_helpers.dart';
import '../../../robots/onboarding_robot.dart';

class MockOnboardingBloc extends Mock implements OnboardingBloc {
  final _controller = StreamController<OnboardingState>.broadcast();

  @override
  Stream<OnboardingState> get stream => _controller.stream;

  @override
  Future<void> close() async {
    await _controller.close();
  }

  @override
  void emit(OnboardingState newState) {
    _controller.add(newState);
  }
}

void main() {
  group('$IntroScreen', () {
    late MockOnboardingBloc mockOnboardingBloc;
    late OnboardingRobot robot;

    setUp(() {
      mockOnboardingBloc = MockOnboardingBloc();
      when(
        () => mockOnboardingBloc.state,
      ).thenReturn(const OnboardingInitial());
      // Ensure the stream emits the initial state immediately upon subscription if needed,
      // but usually BlocListener waits for *changes*.
      // However, initial state is accessed via .state getter usually.
    });

    tearDown(() {
      mockOnboardingBloc.close();
    });

    Future<void> loadIntroScreen(WidgetTester tester) async {
      robot = OnboardingRobot(tester);
      await tester.pumpApp(
        BlocProvider<OnboardingBloc>.value(
          value: mockOnboardingBloc,
          child: const IntroScreen(),
        ),
        usePumpAndSettle: false,
      );
      await tester.pump(const Duration(seconds: 1));
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }
    }

    testWidgets('renders redesigned header and next button', (tester) async {
      await loadIntroScreen(tester);
      await tester.pump(const Duration(seconds: 1));
      robot.expectNextButtonVisible();
    });

    testWidgets('renders correct Lucide icons on each slide', (tester) async {
      await loadIntroScreen(tester);

      // Slide 1
      expect(find.byIcon(LucideIcons.shieldCheck), findsOneWidget);

      // Slide 2
      await robot.tapNext();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byIcon(LucideIcons.wifiOff), findsOneWidget);

      // Slide 3
      await robot.tapNext();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byIcon(LucideIcons.sparkles), findsOneWidget);

      // Slide 4
      await robot.tapNext();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byIcon(LucideIcons.fingerprintPattern), findsOneWidget);
    });

    testWidgets(
      'Tapping next advances slides and shows biometric buttons on last slide',
      (tester) async {
        await loadIntroScreen(tester);

        // Slide 1 -> 2
        await robot.tapNext();
        await tester.pump(const Duration(seconds: 1));

        // Slide 2 -> 3
        await robot.tapNext();
        await tester.pump(const Duration(seconds: 1));

        // Slide 3 -> 4 (Final)
        await robot.tapNext();
        await tester.pump(const Duration(seconds: 1));

        expect(
          find.byKey(const Key('intro_biometric_enable_button')),
          findsOneWidget,
        );
        expect(find.byKey(const Key('intro_done_button')), findsOneWidget);
      },
    );

    testWidgets('Tapping Enable Now dispatches BiometricAuthRequested', (
      tester,
    ) async {
      await loadIntroScreen(tester);

      // Slide 1 -> 2
      await robot.tapNext();
      await tester.pump(const Duration(seconds: 1));
      // Slide 2 -> 3
      await robot.tapNext();
      await tester.pump(const Duration(seconds: 1));
      // Slide 3 -> 4 (Final)
      await robot.tapNext();
      await tester.pump(const Duration(seconds: 1));

      await robot.tapEnableBiometrics();

      verify(
        () => mockOnboardingBloc.add(const BiometricAuthRequested()),
      ).called(1);
    });
  });
}
