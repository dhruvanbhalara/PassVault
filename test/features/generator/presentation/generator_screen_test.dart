import 'package:passvault/features/generator/presentation/bloc/generator/generator_bloc.dart';
import 'package:passvault/features/generator/presentation/generator_screen.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

import '../../../helpers/test_helpers.dart';

class MockGeneratorBloc extends Mock implements GeneratorBloc {
  @override
  Stream<GeneratorState> get stream => Stream.value(state);
}

void main() {
  late MockGeneratorBloc mockGeneratorBloc;
  late AppLocalizations l10n;

  const strategy = PasswordGenerationStrategy(
    id: 'strategy',
    name: 'Default',
    length: 16,
    useUppercase: true,
    useLowercase: true,
    useNumbers: true,
    useSpecialChars: true,
    excludeAmbiguousChars: true,
  );

  const loadedState = GeneratorLoaded(
    strategy: strategy,
    generatedPassword: 'Abc123\$%',
    strength: 0.8,
  );

  setUpAll(() async {
    l10n = await getL10n();
    registerFallbackValue(const GeneratorRequested());
    registerFallbackValue(const GeneratorExcludeAmbiguousToggled(false));
    registerFallbackValue(const GeneratorLengthChanged(17));
  });

  setUp(() {
    mockGeneratorBloc = MockGeneratorBloc();
    when(() => mockGeneratorBloc.state).thenReturn(loadedState);
    when(() => mockGeneratorBloc.close()).thenAnswer((_) async {});
  });

  Future<void> loadScreen(WidgetTester tester) async {
    await tester.pumpApp(
      BlocProvider<GeneratorBloc>.value(
        value: mockGeneratorBloc,
        child: const GeneratorScreen(),
      ),
    );
  }

  group('$GeneratorScreen', () {
    testWidgets(
      'renders generator controls including exclude ambiguous option',
      (tester) async {
        await loadScreen(tester);

        expect(find.text(l10n.passwordGenerator), findsOneWidget);
        expect(find.text(l10n.excludeAmbiguous), findsOneWidget);
        expect(find.byKey(const Key('generator_generate_fab')), findsOneWidget);
        expect(
          find.byKey(const Key('generator_exclude_ambiguous_toggle')),
          findsOneWidget,
        );
      },
    );

    testWidgets('dispatches generate event on generate button tap', (
      tester,
    ) async {
      await loadScreen(tester);

      await tester.tap(find.byKey(const Key('generator_generate_fab')));

      verify(() => mockGeneratorBloc.add(const GeneratorRequested())).called(1);
    });

    testWidgets('dispatches exclude ambiguous toggle event on switch tap', (
      tester,
    ) async {
      await loadScreen(tester);

      final tileFinder = find.byKey(
        const Key('generator_exclude_ambiguous_toggle'),
      );
      await tester.ensureVisible(tileFinder);
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(of: tileFinder, matching: find.byType(Switch)),
      );
      await tester.pump();

      verify(
        () => mockGeneratorBloc.add(
          const GeneratorExcludeAmbiguousToggled(false),
        ),
      ).called(1);
    });

    testWidgets('dispatches length increase event on plus tap', (tester) async {
      await loadScreen(tester);

      await tester.tap(find.byKey(const Key('generator_length_increase')));
      await tester.pump();

      verify(
        () => mockGeneratorBloc.add(const GeneratorLengthChanged(17)),
      ).called(1);
    });
  });
}
