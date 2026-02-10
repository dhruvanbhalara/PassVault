import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/strategy_preview/strategy_preview_bloc.dart';
import 'package:passvault/features/settings/presentation/screens/strategy_editor.dart';

import '../../../../helpers/test_helpers.dart';

class MockStrategyPreviewBloc
    extends MockBloc<StrategyPreviewEvent, StrategyPreviewState>
    implements StrategyPreviewBloc {}

final getIt = GetIt.instance;

void main() {
  late MockStrategyPreviewBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(PasswordGenerationStrategy.create(name: 'Fallback'));
    registerFallbackValue(
      GeneratePreview(PasswordGenerationStrategy.create(name: 'Fallback'))
          as StrategyPreviewEvent,
    );
  });

  setUp(() {
    mockBloc = MockStrategyPreviewBloc();
    // Register mock in GetIt because StrategyEditor uses it internally
    getIt.registerFactory<StrategyPreviewBloc>(() => mockBloc);

    // Stub close() to return a Future<void> as required by MockBloc
    when(() => mockBloc.close()).thenAnswer((_) async => {});
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets('does NOT trigger GeneratePreview when name changes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    when(() => mockBloc.state).thenReturn(const StrategyPreviewInitial());
    when(() => mockBloc.add(any())).thenReturn(null);

    var strategy = PasswordGenerationStrategy.create(name: 'Initial');

    await tester.pumpApp(
      Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) {
            return StrategyEditor(
              strategy: strategy,
              onChanged: (newStrategy) {
                setState(() {
                  strategy = newStrategy;
                });
              },
            );
          },
        ),
      ),
    );

    // Verify total count is still 1 at the end of the test

    // Find name field and enter text
    final nameField = find.widgetWithText(TextField, 'Initial');
    expect(nameField, findsOneWidget);

    await tester.enterText(nameField, 'New Name');
    await tester.pumpAndSettle();

    // Verify GeneratePreview was NOT called again
    verifyNever(
      () => mockBloc.add(
        any(
          that: isA<GeneratePreview>().having(
            (e) => e.settings.name,
            'name',
            'New Name',
          ),
        ),
      ),
    );

    // Verify total count is still 1
    verify(() => mockBloc.add(any(that: isA<GeneratePreview>()))).called(1);
  });

  testWidgets(
    'triggers GeneratePreview when length changes (programmatic update)',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      when(() => mockBloc.state).thenReturn(const StrategyPreviewInitial());
      when(() => mockBloc.add(any())).thenReturn(null);

      final strategyNotifier = ValueNotifier<PasswordGenerationStrategy>(
        PasswordGenerationStrategy.create(name: 'Initial', length: 16),
      );

      await tester.pumpApp(
        SingleChildScrollView(
          child: ValueListenableBuilder<PasswordGenerationStrategy>(
            valueListenable: strategyNotifier,
            builder: (context, strategy, _) {
              return StrategyEditor(
                strategy: strategy,
                onChanged: (newStrategy) {
                  strategyNotifier.value = newStrategy;
                },
              );
            },
          ),
        ),
      );

      // Verify total count is 1 at this point
      verify(() => mockBloc.add(any(that: isA<GeneratePreview>()))).called(1);
      clearInteractions(mockBloc);

      // Programmatically update the widget with new settings
      strategyNotifier.value = strategyNotifier.value.copyWith(length: 24);

      // Trigger rebuild
      await tester.pumpAndSettle();

      // Verify GeneratePreview WAS called again with correct arguments
      verify(
        () => mockBloc.add(
          any(
            that: isA<GeneratePreview>().having(
              (e) => e.settings.length,
              'length',
              24,
            ),
          ),
        ),
      ).called(1);
    },
  );
}
