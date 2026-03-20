import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/generator/presentation/bloc/generator/generator_bloc.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';
import 'package:passvault/features/password_manager/domain/usecases/estimate_password_strength_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/entities/password_strategy_type.dart';
import 'package:passvault/features/settings/domain/usecases/password_settings_usecases.dart';
import 'package:password_engine/password_engine.dart' hide PasswordFeedback;

class MockGeneratePasswordUseCase extends Mock
    implements GeneratePasswordUseCase {}

class MockEstimatePasswordStrengthUseCase extends Mock
    implements EstimatePasswordStrengthUseCase {}

class MockGetPasswordGenerationSettingsUseCase extends Mock
    implements GetPasswordGenerationSettingsUseCase {}

void main() {
  late GeneratorBloc bloc;
  late MockGeneratePasswordUseCase mockGeneratePasswordUseCase;
  late MockEstimatePasswordStrengthUseCase mockEstimatePasswordStrengthUseCase;
  late MockGetPasswordGenerationSettingsUseCase mockGetSettingsUseCase;

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
    mockEstimatePasswordStrengthUseCase = MockEstimatePasswordStrengthUseCase();
    mockGetSettingsUseCase = MockGetPasswordGenerationSettingsUseCase();

    when(
      () => mockGetSettingsUseCase(),
    ).thenReturn(Success(PasswordGenerationSettings.initial()));

    when(
      () => mockGeneratePasswordUseCase(strategy: any(named: 'strategy')),
    ).thenReturn('generatedPassword');

    when(
      () => mockEstimatePasswordStrengthUseCase(any()),
    ).thenReturn(const PasswordFeedback(strength: PasswordStrength.strong));

    bloc = GeneratorBloc(
      mockGeneratePasswordUseCase,
      mockEstimatePasswordStrengthUseCase,
      mockGetSettingsUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('$GeneratorBloc', () {
    test('initial state is GeneratorLoaded (after started)', () {
      expect(bloc.state, isA<GeneratorLoaded>());
    });

    blocTest<GeneratorBloc, GeneratorState>(
      'emits GeneratorLoaded with updated length on GeneratorLengthChanged',
      build: () => bloc,
      act: (bloc) => bloc.add(const GeneratorLengthChanged(20)),
      verify: (bloc) {
        if (bloc.state case GeneratorLoaded(:final strategy)) {
          expect(strategy.length, 20);
        } else {
          fail('State should be GeneratorLoaded');
        }
      },
    );

    blocTest<GeneratorBloc, GeneratorState>(
      'emits new password on GeneratorRequested',
      build: () => bloc,
      act: (bloc) => bloc.add(const GeneratorRequested()),
      verify: (bloc) {
        verify(
          () => mockGeneratePasswordUseCase(strategy: any(named: 'strategy')),
        ).called(2); // One for initial started, one for requested
      },
    );

    blocTest<GeneratorBloc, GeneratorState>(
      'toggles uppercase on GeneratorUppercaseToggled',
      build: () => bloc,
      act: (bloc) => bloc.add(const GeneratorUppercaseToggled(false)),
      verify: (bloc) {
        if (bloc.state case GeneratorLoaded(:final strategy)) {
          expect(strategy.useUppercase, false);
        } else {
          fail('State should be GeneratorLoaded');
        }
      },
    );

    blocTest<GeneratorBloc, GeneratorState>(
      'updates word count when GeneratorWordCountChanged is added',
      build: () {
        when(() => mockGetSettingsUseCase()).thenReturn(
          const Success(
            PasswordGenerationSettings(
              strategies: [
                PasswordGenerationStrategy(
                  id: 'memorable-strategy',
                  name: 'Memorable',
                  type: PasswordStrategyType.memorable,
                  wordCount: 4,
                ),
              ],
              defaultStrategyId: 'memorable-strategy',
            ),
          ),
        );
        return GeneratorBloc(
          mockGeneratePasswordUseCase,
          mockEstimatePasswordStrengthUseCase,
          mockGetSettingsUseCase,
        );
      },
      act: (bloc) => bloc.add(const GeneratorWordCountChanged(6)),
      verify: (bloc) {
        if (bloc.state case GeneratorLoaded(:final strategy)) {
          expect(strategy.wordCount, 6);
        } else {
          fail('State should be GeneratorLoaded');
        }
      },
    );

    blocTest<GeneratorBloc, GeneratorState>(
      'updates separator when GeneratorSeparatorChanged is added',
      build: () {
        when(() => mockGetSettingsUseCase()).thenReturn(
          const Success(
            PasswordGenerationSettings(
              strategies: [
                PasswordGenerationStrategy(
                  id: 'memorable-strategy',
                  name: 'Memorable',
                  type: PasswordStrategyType.memorable,
                  separator: '-',
                ),
              ],
              defaultStrategyId: 'memorable-strategy',
            ),
          ),
        );
        return GeneratorBloc(
          mockGeneratePasswordUseCase,
          mockEstimatePasswordStrengthUseCase,
          mockGetSettingsUseCase,
        );
      },
      act: (bloc) => bloc.add(const GeneratorSeparatorChanged('_')),
      verify: (bloc) {
        if (bloc.state case GeneratorLoaded(:final strategy)) {
          expect(strategy.separator, '_');
        } else {
          fail('State should be GeneratorLoaded');
        }
      },
    );

    blocTest<GeneratorBloc, GeneratorState>(
      'emits new strategy on GeneratorStrategySelected',
      build: () {
        when(() => mockGetSettingsUseCase()).thenReturn(
          const Success(
            PasswordGenerationSettings(
              strategies: [
                PasswordGenerationStrategy(
                  id: 'default-strategy',
                  name: 'Default',
                ),
                PasswordGenerationStrategy(
                  id: 'custom-strategy',
                  name: 'Custom',
                  length: 32,
                ),
              ],
              defaultStrategyId: 'default-strategy',
            ),
          ),
        );
        return GeneratorBloc(
          mockGeneratePasswordUseCase,
          mockEstimatePasswordStrengthUseCase,
          mockGetSettingsUseCase,
        );
      },
      act: (bloc) =>
          bloc.add(const GeneratorStrategySelected('custom-strategy')),
      verify: (bloc) {
        if (bloc.state case GeneratorLoaded(:final strategy)) {
          expect(strategy.id, 'custom-strategy');
          expect(strategy.length, 32);
        } else {
          fail('State should be GeneratorLoaded');
        }
      },
    );

    blocTest<GeneratorBloc, GeneratorState>(
      'does not emit new state when same strategy is selected',
      build: () {
        when(() => mockGetSettingsUseCase()).thenReturn(
          const Success(
            PasswordGenerationSettings(
              strategies: [
                PasswordGenerationStrategy(
                  id: 'default-strategy',
                  name: 'Default',
                ),
              ],
              defaultStrategyId: 'default-strategy',
            ),
          ),
        );
        return GeneratorBloc(
          mockGeneratePasswordUseCase,
          mockEstimatePasswordStrengthUseCase,
          mockGetSettingsUseCase,
        );
      },
      act: (bloc) =>
          bloc.add(const GeneratorStrategySelected('default-strategy')),
      skip: 1,
      expect: () => <GeneratorState>[],
    );
  });
}
