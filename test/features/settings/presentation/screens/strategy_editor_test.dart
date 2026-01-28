import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/app_theme.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/strategy_preview/strategy_preview_bloc.dart';
import 'package:passvault/features/settings/presentation/screens/strategy_editor.dart';
import 'package:passvault/l10n/app_localizations.dart';

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
    reset(mockBloc);
    getIt.reset();
  });

  Widget createTestWidget(
    PasswordGenerationStrategy strategy, {
    required ValueChanged<PasswordGenerationStrategy> onChanged,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: SingleChildScrollView(
          child: StrategyEditor(strategy: strategy, onChanged: onChanged),
        ),
      ),
    );
  }

  testWidgets('does NOT trigger GeneratePreview when name changes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    when(() => mockBloc.state).thenReturn(StrategyPreviewState.initial());
    when(() => mockBloc.add(any())).thenReturn(null);

    var strategy = PasswordGenerationStrategy.create(name: 'Initial');

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return createTestWidget(
            strategy,
            onChanged: (newStrategy) {
              setState(() {
                strategy = newStrategy;
              });
            },
          );
        },
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
            (e) => e.settings.name == 'New Name',
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

      when(() => mockBloc.state).thenReturn(StrategyPreviewState.initial());
      when(() => mockBloc.add(any())).thenReturn(null);

      var strategy = PasswordGenerationStrategy.create(
        name: 'Initial',
        length: 16,
      );

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return createTestWidget(
              strategy,
              onChanged: (newStrategy) {
                setState(() {
                  strategy = newStrategy;
                });
              },
            );
          },
        ),
      );

      // Verify total count is 1 at this point
      verify(() => mockBloc.add(any(that: isA<GeneratePreview>()))).called(1);

      // Programmatically update the widget with new settings
      final newStrategy = strategy.copyWith(length: 24);

      // Re-pump createTestWidget directly (simulating parent rebuild)
      await tester.pumpWidget(createTestWidget(newStrategy, onChanged: (_) {}));
      // Needed to flush microtasks
      await tester.pump();

      // Verify GeneratePreview WAS called again
      verify(() => mockBloc.add(any(that: isA<GeneratePreview>()))).called(1);
    },
  );
}
