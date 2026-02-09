import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/strategy_preview/strategy_preview_bloc.dart';

class MockGeneratePasswordUseCase extends Mock
    implements GeneratePasswordUseCase {}

void main() {
  late MockGeneratePasswordUseCase mockGeneratePasswordUseCase;
  late StrategyPreviewBloc bloc;

  setUp(() {
    mockGeneratePasswordUseCase = MockGeneratePasswordUseCase();
    bloc = StrategyPreviewBloc(mockGeneratePasswordUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('StrategyPreviewBloc', () {
    final settings = PasswordGenerationStrategy.create(name: 'Test');
    const generatedPassword = 'mockPassword123';

    test('initial state is correct', () {
      expect(bloc.state, const StrategyPreviewInitial());
    });

    blocTest<StrategyPreviewBloc, StrategyPreviewState>(
      'emits [loading, success] when GeneratePreview event succeeds',
      build: () {
        when(
          () => mockGeneratePasswordUseCase(
            length: any(named: 'length'),
            useNumbers: any(named: 'useNumbers'),
            useSpecialChars: any(named: 'useSpecialChars'),
            useUppercase: any(named: 'useUppercase'),
            useLowercase: any(named: 'useLowercase'),
            excludeAmbiguousChars: any(named: 'excludeAmbiguousChars'),
          ),
        ).thenReturn(generatedPassword);
        return bloc;
      },
      act: (bloc) => bloc.add(GeneratePreview(settings)),
      expect: () => [
        const StrategyPreviewLoading(),
        const StrategyPreviewSuccess(password: generatedPassword),
      ],
    );

    blocTest<StrategyPreviewBloc, StrategyPreviewState>(
      'emits [loading, failure] when GeneratePreview event fails',
      build: () {
        when(
          () => mockGeneratePasswordUseCase(
            length: any(named: 'length'),
            useNumbers: any(named: 'useNumbers'),
            useSpecialChars: any(named: 'useSpecialChars'),
            useUppercase: any(named: 'useUppercase'),
            useLowercase: any(named: 'useLowercase'),
            excludeAmbiguousChars: any(named: 'excludeAmbiguousChars'),
          ),
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
