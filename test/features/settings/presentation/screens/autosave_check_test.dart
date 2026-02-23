import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/strategy_preview/strategy_preview_bloc.dart';
import 'package:passvault/features/settings/presentation/screens/strategy_editor_screen.dart';

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

class MockStrategyPreviewBloc
    extends MockBloc<StrategyPreviewEvent, StrategyPreviewState>
    implements StrategyPreviewBloc {}

final getIt = GetIt.instance;

void main() {
  late MockSettingsBloc mockSettingsBloc;
  late MockStrategyPreviewBloc mockPreviewBloc;

  setUpAll(() {
    registerFallbackValue(SettingsInitial());
    registerFallbackValue(const LoadSettings());
    registerFallbackValue(
      GeneratePreview(PasswordGenerationStrategy.create(name: 'Fallback'))
          as StrategyPreviewEvent,
    );
    registerFallbackValue(
      const PasswordGenerationStrategy(id: 'fb', name: 'Fallback'),
    );
  });

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
    mockPreviewBloc = MockStrategyPreviewBloc();

    getIt.registerSingleton<StrategyPreviewBloc>(mockPreviewBloc);
    getIt.registerSingleton<SettingsBloc>(mockSettingsBloc);

    final successState = const SettingsLoaded(
      useBiometrics: false,
      passwordSettings: PasswordGenerationSettings(
        strategies: [
          PasswordGenerationStrategy(id: 'default-id', name: 'Default'),
        ],
        defaultStrategyId: 'default-id',
      ),
    );

    whenListen(
      mockSettingsBloc,
      Stream.value(successState),
      initialState: successState,
    );

    // Also mock just in case direct access happens
    when(() => mockSettingsBloc.state).thenReturn(successState);

    when(
      () => mockPreviewBloc.state,
    ).thenReturn(const StrategyPreviewInitial());
    when(() => mockPreviewBloc.add(any())).thenReturn(null);
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets(
    'Closing StrategyEditor without saving should NOT update settings',
    (tester) async {
      // 1. Pump the screen with a simplified Theme and Size
      tester.view.physicalSize = const Size(
        1200,
        2400,
      ); // 400dp width to avoid overflow
      tester.view.devicePixelRatio = 3.0;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
          home: BlocProvider<SettingsBloc>.value(
            value: mockSettingsBloc,
            child: const StrategyEditorScreen(strategyId: 'default-id'),
          ),
        ),
      );

      // Verify basic widget existence
      expect(find.byType(StrategyEditorScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final nameField = find.widgetWithText(TextField, 'Default');
      expect(nameField, findsOneWidget);

      // 3. Change Name
      await tester.enterText(nameField, 'Changed Name');
      await tester.pump();

      // 4. Close sheet (Simulate Back / Scrim Tap)
      // Using handlePopRoute simulates system back or scrim dismissal
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      // 5. Verify SettingsBloc did NOT receive UpdateStrategy
      verifyNever(() => mockSettingsBloc.add(any(that: isA<UpdateStrategy>())));
      verifyNever(() => mockSettingsBloc.add(any(that: isA<AddStrategy>())));
    },
  );
}
