import 'package:passvault/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:passvault/features/onboarding/presentation/intro_screen.dart';

import '../../../helpers/test_helpers.dart';
import '../../../robots/onboarding_robot.dart';

class MockOnboardingBloc extends Mock implements OnboardingBloc {
  @override
  Stream<OnboardingState> get stream => Stream.value(state);
}

void main() {
  late MockOnboardingBloc mockOnboardingBloc;
  late OnboardingRobot robot;

  setUp(() {
    mockOnboardingBloc = MockOnboardingBloc();
    when(() => mockOnboardingBloc.close()).thenAnswer((_) async {});
    when(() => mockOnboardingBloc.state).thenReturn(OnboardingInitial());
  });

  Future<void> loadIntroScreen(WidgetTester tester) async {
    robot = OnboardingRobot(tester);
    await tester.pumpApp(
      BlocProvider<OnboardingBloc>.value(
        value: mockOnboardingBloc,
        child: const IntroView(),
      ),
    );
  }

  group('$IntroScreen', () {
    testWidgets('PageView and buttons are visible', (tester) async {
      await loadIntroScreen(tester);

      robot.expectPageViewVisible();
      robot.expectSkipButtonVisible();
      robot.expectNextButtonVisible();
    });

    testWidgets('Tapping next moves to next page', (tester) async {
      await loadIntroScreen(tester);

      await robot.tapNext();

      robot.expectSkipButtonVisible();
    });
  });
}
