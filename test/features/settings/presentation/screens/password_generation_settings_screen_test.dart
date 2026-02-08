import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/app_theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/strategy_preview/strategy_preview_bloc.dart';
import 'package:passvault/features/settings/presentation/screens/password_generation_settings_screen.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockSettingsBloc extends Mock implements SettingsBloc {
  @override
  Stream<SettingsState> get stream => Stream.value(state);
}

class MockStrategyPreviewBloc extends Mock implements StrategyPreviewBloc {
  @override
  Stream<StrategyPreviewState> get stream =>
      Stream.value(StrategyPreviewState.initial());
}

void main() {
  late MockSettingsBloc mockSettingsBloc;

  setUpAll(() {
    registerFallbackValue(
      const PasswordGenerationStrategy(id: 'fallback', name: 'fallback'),
    );
  });

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
    // Register mock bloc for StrategyPreview
    if (getIt.isRegistered<StrategyPreviewBloc>()) {
      getIt.unregister<StrategyPreviewBloc>();
    }
    getIt.registerFactory<StrategyPreviewBloc>(() => MockStrategyPreviewBloc());

    if (getIt.isRegistered<SettingsBloc>()) {
      getIt.unregister<SettingsBloc>();
    }
    getIt.registerSingleton<SettingsBloc>(mockSettingsBloc);

    when(() => mockSettingsBloc.close()).thenAnswer((_) async {});
  });

  tearDown(() {
    getIt.reset();
  });

  Widget createTestWidget() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: const PasswordGenerationSettingsScreen(),
    );
  }

  testWidgets('Renders PasswordGenerationSettingsScreen with strategies', (
    tester,
  ) async {
    final strategy = PasswordGenerationStrategy.create(name: 'My Strategy');
    when(() => mockSettingsBloc.state).thenReturn(
      SettingsState(
        passwordSettings: PasswordGenerationSettings(
          strategies: [strategy],
          defaultStrategyId: strategy.id,
        ),
      ),
    );

    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    expect(find.byType(PasswordGenerationSettingsScreen), findsOneWidget);
    expect(find.text('My Strategy'), findsOneWidget);
  });
}
