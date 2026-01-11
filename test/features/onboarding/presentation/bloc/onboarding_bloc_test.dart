import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:passvault/features/settings/domain/usecases/onboarding_usecases.dart';

class MockSetOnboardingCompleteUseCase extends Mock
    implements SetOnboardingCompleteUseCase {}

void main() {
  late OnboardingBloc bloc;
  late MockSetOnboardingCompleteUseCase mockSetOnboardingCompleteUseCase;

  setUp(() {
    mockSetOnboardingCompleteUseCase = MockSetOnboardingCompleteUseCase();
    bloc = OnboardingBloc(mockSetOnboardingCompleteUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('OnboardingBloc', () {
    test('initial state is OnboardingInitial', () {
      expect(bloc.state, isA<OnboardingInitial>());
    });

    group('CompleteOnboarding', () {
      test('emits OnboardingSuccess and calls use case', () async {
        when(
          () => mockSetOnboardingCompleteUseCase(any()),
        ).thenAnswer((_) async => const Success(null));

        final states = <OnboardingState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(CompleteOnboarding());

        await Future.delayed(const Duration(milliseconds: 100));
        await subscription.cancel();

        expect(states.length, 1);
        expect(states.last, isA<OnboardingSuccess>());

        verify(() => mockSetOnboardingCompleteUseCase(true)).called(1);
      });
    });
  });
}
