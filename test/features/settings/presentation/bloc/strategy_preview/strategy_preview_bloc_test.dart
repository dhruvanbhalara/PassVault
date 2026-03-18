import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';
import 'package:passvault/features/password_manager/domain/usecases/estimate_password_strength_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/strategy_preview/strategy_preview_bloc.dart';
import 'package:password_engine/password_engine.dart' hide PasswordFeedback;

class MockGeneratePasswordUseCase extends Mock
    implements GeneratePasswordUseCase {}

class MockEstimatePasswordStrengthUseCase extends Mock
    implements EstimatePasswordStrengthUseCase {}

void main() {
  late MockGeneratePasswordUseCase mockGeneratePasswordUseCase;
  late MockEstimatePasswordStrengthUseCase mockEstimateStrengthUseCase;
  late StrategyPreviewBloc bloc;

  setUpAll(() {
    registerFallbackValue(
      const PasswordGenerationStrategy(
        id: 'fallback',
        name: 'Fallback',
        length: 16,
      ),
    );
  });

  setUp(() {
    mockGeneratePasswordUseCase = MockGeneratePasswordUseCase();
    mockEstimateStrengthUseCase = MockEstimatePasswordStrengthUseCase();
    bloc = StrategyPreviewBloc(
      mockGeneratePasswordUseCase,
      mockEstimateStrengthUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group(r'$StrategyPreviewBloc', () {
    final settings = PasswordGenerationStrategy.create(name: 'Test');
    const generatedPassword = 'mockPassword123';

    test('initial state is correct', () {
      expect(bloc.state, const StrategyPreviewInitial());
    });

    blocTest<StrategyPreviewBloc, StrategyPreviewState>(
      'emits [loading, success] when GeneratePreview event succeeds',
      build: () {
        when(
          () => mockGeneratePasswordUseCase(strategy: any(named: 'strategy')),
        ).thenReturn(generatedPassword);
        when(
          () => mockEstimateStrengthUseCase(any()),
        ).thenReturn(const PasswordFeedback(strength: PasswordStrength.medium));
        return bloc;
      },
      act: (bloc) => bloc.add(GeneratePreview(settings)),
      expect: () => [
        const StrategyPreviewLoading(),
        const StrategyPreviewSuccess(
          password: generatedPassword,
          strength: PasswordFeedback(strength: PasswordStrength.medium),
        ),
      ],
    );

    blocTest<StrategyPreviewBloc, StrategyPreviewState>(
      'emits [loading, failure] when GeneratePreview event fails',
      build: () {
        when(
          () => mockGeneratePasswordUseCase(strategy: any(named: 'strategy')),
        ).thenThrow(Exception('Generation Failed'));
        return bloc;
      },
      act: (bloc) => bloc.add(GeneratePreview(settings)),
      expect: () => [
        const StrategyPreviewLoading(),
        const StrategyPreviewFailure(errorMessage: 'error_generating_password'),
      ],
    );
  });
}
