import 'package:passvault/features/home/presentation/bloc/password/password_bloc.dart';
import 'package:passvault/features/home/presentation/home_screen.dart';

import '../../../fixtures/password_fixtures.dart';
import '../../../helpers/test_helpers.dart';
import '../../../robots/home_robot.dart';

class MockPasswordBloc extends Mock implements PasswordBloc {
  @override
  Stream<PasswordState> get stream => Stream.value(state);
}

void main() {
  late MockPasswordBloc mockPasswordBloc;
  late HomeRobot robot;

  setUp(() {
    mockPasswordBloc = MockPasswordBloc();
    when(() => mockPasswordBloc.close()).thenAnswer((_) async {});
  });

  Future<void> loadHomeScreen(
    WidgetTester tester,
    PasswordState state, {
    bool usePumpAndSettle = true,
  }) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    robot = HomeRobot(tester);
    when(() => mockPasswordBloc.state).thenReturn(state);

    await tester.pumpApp(
      BlocProvider<PasswordBloc>.value(
        value: mockPasswordBloc,
        child: const HomeScreen(),
      ),
      usePumpAndSettle: usePumpAndSettle,
    );
  }

  group('$HomeScreen', () {
    testWidgets('renders all essential UI components', (tester) async {
      await loadHomeScreen(tester, const PasswordLoaded([]));

      expect(find.byKey(const Key('home_fab')), findsOneWidget);
    });

    testWidgets('shows loading state correctly', (tester) async {
      await loadHomeScreen(
        tester,
        const PasswordLoading(),
        usePumpAndSettle: false,
      );

      robot.expectLoading();
    });

    testWidgets('shows empty state when no passwords exist', (tester) async {
      await loadHomeScreen(tester, const PasswordLoaded([]));

      robot.expectEmptyState();
    });

    testWidgets('renders password list when data is loaded', (tester) async {
      final passwords = PasswordFixtures.list;
      await loadHomeScreen(tester, PasswordLoaded(passwords));

      robot.expectPasswordListVisible();
      robot.expectPasswordVisible('Google');
      robot.expectPasswordVisible('Facebook');
      robot.expectPasswordsCount(3);
    });

    testWidgets('FAB is a FloatingActionButton', (tester) async {
      await loadHomeScreen(tester, const PasswordLoaded([]));

      final fab = tester.widget<FloatingActionButton>(
        find.byKey(const Key('home_fab')),
      );

      expect(fab, isA<FloatingActionButton>());
    });
  });
}
