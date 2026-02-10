import 'package:passvault/features/auth/presentation/auth_screen.dart';
import 'package:passvault/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../helpers/test_helpers.dart';
import '../../../robots/auth_robot.dart';

class MockAuthBloc extends Mock implements AuthBloc {
  @override
  Stream<AuthState> get stream => Stream.value(state);
}

void main() {
  late MockAuthBloc mockAuthBloc;
  late AuthRobot robot;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.close()).thenAnswer((_) async {});
  });

  Future<void> loadAuthScreen(
    WidgetTester tester,
    AuthState state, {
    bool usePumpAndSettle = true,
  }) async {
    robot = AuthRobot(tester);
    when(() => mockAuthBloc.state).thenReturn(state);
    await tester.pumpApp(
      BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const AuthView(),
      ),
      usePumpAndSettle: usePumpAndSettle,
    );
  }

  group('$AuthScreen', () {
    testWidgets('Shows loading indicator with correct key', (tester) async {
      await loadAuthScreen(tester, AuthLoading(), usePumpAndSettle: false);

      robot.expectLoading();
    });

    testWidgets('Shows AppButton when not loading', (tester) async {
      await loadAuthScreen(tester, AuthInitial(), usePumpAndSettle: false);

      robot.expectUnlockButtonVisible();
    });
  });
}
