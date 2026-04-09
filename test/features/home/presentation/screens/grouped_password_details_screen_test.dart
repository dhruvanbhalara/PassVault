import 'package:go_router/go_router.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/features/home/domain/entities/grouped_home_entry.dart';
import 'package:passvault/features/home/presentation/bloc/password/password_bloc.dart';
import 'package:passvault/features/home/presentation/screens/grouped_password_details_screen.dart';
import 'package:passvault/features/home/presentation/widgets/password_list_tile.dart';

import '../../../../fixtures/password_fixtures.dart';
import '../../../../helpers/test_helpers.dart';

class MockPasswordBloc extends Mock implements PasswordBloc {
  @override
  Stream<PasswordState> get stream => Stream.value(state);
}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockPasswordBloc mockPasswordBloc;
  late MockGoRouter mockGoRouter;
  late List<GroupedHomeEntry> groupedEntries;
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await getL10n();
  });

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
          PasswordFixtures.google.copyWith(
            id: 'google-2',
            username: 'user2@gmail.com',
          ),
        ],
      ),
    ];
  });

  Future<void> loadScreen(
    WidgetTester tester, {
    required PasswordState state,
    required String groupKey,
  }) async {
    when(() => mockPasswordBloc.state).thenReturn(state);

    await tester.pumpApp(
      InheritedGoRouter(
        goRouter: mockGoRouter,
        child: BlocProvider<PasswordBloc>.value(
          value: mockPasswordBloc,
          child: GroupedPasswordDetailsScreen(groupKey: groupKey),
        ),
      ),
    );
  }

  group('$GroupedPasswordDetailsScreen', () {
    testWidgets('renders all members for the selected group', (tester) async {
      await loadScreen(
        tester,
        state: PasswordLoaded(
          passwords: PasswordFixtures.list,
          groupedEntries: groupedEntries,
        ),
        groupKey: 'google.com',
      );

      expect(
        find.byKey(const Key('grouped_details_member_list')),
        findsOneWidget,
      );
      expect(find.byType(PasswordListTile), findsNWidgets(2));
      expect(find.text(l10n.groupedCredentialCount(2)), findsOneWidget);
    });

    testWidgets('shows not-found state when group is unavailable', (
      tester,
    ) async {
      await loadScreen(
        tester,
        state: PasswordLoaded(
          passwords: PasswordFixtures.list,
          groupedEntries: const [],
        ),
        groupKey: 'missing.com',
      );

      expect(
        find.byKey(const Key('grouped_details_not_found_text')),
        findsOneWidget,
      );
      expect(find.text(l10n.groupedEntryNotFound), findsOneWidget);
    });

    testWidgets('keeps existing account edit action in grouped details', (
      tester,
    ) async {
      when(
        () => mockGoRouter.push(any(), extra: any(named: 'extra')),
      ).thenAnswer((_) async => null);
      await loadScreen(
        tester,
        state: PasswordLoaded(
          passwords: PasswordFixtures.list,
          groupedEntries: groupedEntries,
        ),
        groupKey: 'google.com',
      );

      await tester.tap(find.text(PasswordFixtures.google.appName).first);
      await tester.pumpAndSettle();

      verify(
        () => mockGoRouter.push(
          AppRoutes.editPassword,
          extra: PasswordFixtures.google,
        ),
      ).called(1);
    });
  });
}
