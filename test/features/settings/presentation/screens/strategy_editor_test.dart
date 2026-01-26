import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/design_system/theme/app_theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/strategy_preview/strategy_preview_bloc.dart';
import 'package:passvault/features/settings/presentation/screens/strategy_editor.dart';
import 'package:passvault/l10n/app_localizations.dart';

class MockStrategyPreviewBloc extends Mock implements StrategyPreviewBloc {
  @override
  Stream<StrategyPreviewState> get stream =>
      Stream.value(StrategyPreviewState.initial());
}

void main() {
  late MockStrategyPreviewBloc mockStrategyPreviewBloc;

  setUpAll(() {
    const fallbackStrategy = PasswordGenerationStrategy(
      id: 'fallback',
      name: 'fallback',
    );
    registerFallbackValue(fallbackStrategy);
    registerFallbackValue(const GeneratePreview(fallbackStrategy));
  });

  setUp(() {
    mockStrategyPreviewBloc = MockStrategyPreviewBloc();
    // Verify add is called, so stub it to return void
    when(() => mockStrategyPreviewBloc.add(any())).thenReturn(null);
    when(() => mockStrategyPreviewBloc.close()).thenAnswer((_) async {});
    when(
      () => mockStrategyPreviewBloc.state,
    ).thenReturn(StrategyPreviewState.initial());

    if (getIt.isRegistered<StrategyPreviewBloc>()) {
      getIt.unregister<StrategyPreviewBloc>();
    }
    getIt.registerFactory<StrategyPreviewBloc>(() => mockStrategyPreviewBloc);
  });

  tearDown(() {
    getIt.reset();
  });

  Widget createTestWidget(PasswordGenerationStrategy strategy) {
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
          child: StrategyEditor(strategy: strategy, onChanged: (_) {}),
        ),
      ),
    );
  }

  testWidgets('StrategyEditor renders correctly', (tester) async {
    final strategy = PasswordGenerationStrategy.create(name: 'Test Strategy');

    await tester.pumpWidget(createTestWidget(strategy));
    await tester.pumpAndSettle();

    expect(find.text('Test Strategy'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Verify preview generation is triggered via event
    verify(
      () => mockStrategyPreviewBloc.add(any(that: isA<GeneratePreview>())),
    ).called(1);
  });
}
