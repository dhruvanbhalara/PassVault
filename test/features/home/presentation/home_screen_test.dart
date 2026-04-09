import 'package:go_router/go_router.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/features/home/domain/entities/grouped_home_entry.dart';
import 'package:passvault/features/home/presentation/bloc/password/password_bloc.dart';
import 'package:passvault/features/home/presentation/home_screen.dart';
import 'package:passvault/features/home/presentation/widgets/grouped_password_list_tile.dart';

import '../../../fixtures/password_fixtures.dart';
import '../../../helpers/test_helpers.dart';
import '../../../robots/home_robot.dart';

class MockPasswordBloc extends Mock implements PasswordBloc {
  @override
  Stream<PasswordState> get stream => Stream.value(state);
}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockPasswordBloc mockPasswordBloc;
  late MockGoRouter mockGoRouter;
  late HomeRobot robot;
  late List<GroupedHomeEntry> groupedEntries;

  setUp(() {
    mockPasswordBloc = MockPasswordBloc();
    mockGoRouter = MockGoRouter();
    when(() => mockPasswordBloc.close()).thenAnswer((_) async {});
    groupedEntries = [
      GroupedHomeEntry(
        canonicalKey: 'google.com',
        displayName: 'google.com',
        members: [
          PasswordFixtures.google,
          PasswordFixtures.google.copyWith(id: 'google-2'),
        ],
      ),
      GroupedHomeEntry(
        canonicalKey: 'facebook.com',
        displayName: 'facebook.com',
        members: [PasswordFixtures.facebook],
      ),
    ];
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
      InheritedGoRouter(
        goRouter: mockGoRouter,
        child: BlocProvider<PasswordBloc>.value(
          value: mockPasswordBloc,
          child: const HomeScreen(),
        ),
      ),
      usePumpAndSettle: usePumpAndSettle,
    );
  }

  group('$HomeScreen', () {
    testWidgets('renders grouped list when data is loaded', (tester) async {
      await loadHomeScreen(
        tester,
        PasswordLoaded(
          passwords: PasswordFixtures.list,
          groupedEntries: groupedEntries,
        ),
      );

      robot.expectPasswordListVisible();
      expect(find.byType(GroupedPasswordListTile), findsNWidgets(2));
    });

    testWidgets('navigates to grouped details when group is tapped', (
      tester,
    ) async {
      when(() => mockGoRouter.push(any())).thenAnswer((_) async => null);
      await loadHomeScreen(
        tester,
        PasswordLoaded(
          passwords: PasswordFixtures.list,
          groupedEntries: groupedEntries,
        ),
      );

      await tester.tap(find.text(groupedEntries.first.displayName));
      await tester.pumpAndSettle();

      verify(
        () => mockGoRouter.push(
          AppRoutes.groupedPasswordDetailsPath('google.com'),
        ),
      ).called(1);
    });
  });
}
