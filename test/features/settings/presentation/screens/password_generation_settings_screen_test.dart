import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/strategy_preview/strategy_preview_bloc.dart';
import 'package:passvault/features/settings/presentation/screens/strategy_screen.dart';

import '../../../../helpers/test_helpers.dart';

class MockSettingsBloc extends Mock implements SettingsBloc {
  @override
  Stream<SettingsState> get stream => Stream.value(state);
}

class MockStrategyPreviewBloc extends Mock implements StrategyPreviewBloc {
  @override
  Stream<StrategyPreviewState> get stream =>
      Stream.value(const StrategyPreviewInitial());
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

  testWidgets('Renders PasswordGenerationSettingsScreen with strategies', (
    tester,
  ) async {
    final strategy = PasswordGenerationStrategy.create(name: 'My Strategy');
    when(() => mockSettingsBloc.state).thenReturn(
      SettingsLoaded(
        useBiometrics: false,
        passwordSettings: PasswordGenerationSettings(
          strategies: [strategy],
          defaultStrategyId: strategy.id,
        ),
      ),
    );

    await tester.pumpApp(
      BlocProvider<SettingsBloc>.value(
        value: mockSettingsBloc,
        child: const StrategyScreen(),
      ),
    );

    expect(find.byType(StrategyScreen), findsOneWidget);
    expect(find.text('My Strategy'), findsOneWidget);
  });
}
