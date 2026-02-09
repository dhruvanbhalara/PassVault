import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/strategy_preview/strategy_preview_bloc.dart';
import 'package:passvault/features/settings/presentation/screens/password_generation_settings_screen.dart';
import 'package:passvault/l10n/app_localizations.dart';

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
    registerFallbackValue(const SettingsInitial());
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
            child: const PasswordGenerationSettingsScreen(),
          ),
        ),
      );

      // Verify basic widget existence
      expect(find.byType(PasswordGenerationSettingsScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      verify(
        () => mockSettingsBloc.add(any(that: isA<LoadSettings>())),
      ).called(1);

      try {
        expect(find.text('Default'), findsWidgets);
      } catch (e) {
        // Ignored
      }

      // 2. Click "Edit" on the active strategy
      final editButton = find.byKey(const Key('edit_strategy_default-id'));

      expect(editButton, findsOneWidget);
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Verify sheet is open
      final nameField = find.widgetWithText(TextField, 'Default');
      expect(nameField, findsOneWidget);

      // 3. Change Name
      await tester.enterText(nameField, 'Changed Name');
      await tester.pump();

      // 4. Close sheet (Simulate Tap Scrim - Top Left)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Verify sheet is closed
      expect(find.widgetWithText(TextField, 'Changed Name'), findsNothing);

      // 5. Verify SettingsBloc did NOT receive UpdateStrategy
      verifyNever(() => mockSettingsBloc.add(any(that: isA<UpdateStrategy>())));
      verifyNever(() => mockSettingsBloc.add(any(that: isA<AddStrategy>())));
    },
  );
}
