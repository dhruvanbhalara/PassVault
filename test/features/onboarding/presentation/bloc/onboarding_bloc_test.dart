import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/auth/domain/usecases/authenticate_usecase.dart';
import 'package:passvault/features/auth/domain/usecases/check_biometrics_usecase.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding/onboarding_bloc.dart';
import 'package:passvault/features/settings/domain/usecases/biometrics_usecases.dart';
import 'package:passvault/features/settings/domain/usecases/onboarding_usecases.dart';

class MockGetOnboardingCompleteUseCase extends Mock
    implements GetOnboardingCompleteUseCase {}

class MockSetOnboardingCompleteUseCase extends Mock
    implements SetOnboardingCompleteUseCase {}

class MockSetBiometricsEnabledUseCase extends Mock
    implements SetBiometricsEnabledUseCase {}

class MockDeleteOnboardingStepUseCase extends Mock
    implements DeleteOnboardingStepUseCase {}

class MockCheckBiometricsUseCase extends Mock
    implements CheckBiometricsUseCase {}

class MockAuthenticateUseCase extends Mock implements AuthenticateUseCase {}

void main() {
  group('$OnboardingBloc', () {
    late OnboardingBloc bloc;
    late GetOnboardingCompleteUseCase getOnboardingComplete;
    late SetOnboardingCompleteUseCase setOnboardingComplete;
    late SetBiometricsEnabledUseCase setBiometricsEnabled;
    late CheckBiometricsUseCase checkBiometrics;
    late AuthenticateUseCase authenticate;
    late DeleteOnboardingStepUseCase deleteOnboardingStep;

    setUp(() {
      getOnboardingComplete = MockGetOnboardingCompleteUseCase();
      setOnboardingComplete = MockSetOnboardingCompleteUseCase();
      setBiometricsEnabled = MockSetBiometricsEnabledUseCase();
      checkBiometrics = MockCheckBiometricsUseCase();
      authenticate = MockAuthenticateUseCase();
      deleteOnboardingStep = MockDeleteOnboardingStepUseCase();

      bloc = OnboardingBloc(
        getOnboardingComplete,
        setOnboardingComplete,
        setBiometricsEnabled,
        checkBiometrics,
        authenticate,
        deleteOnboardingStep,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is OnboardingInitial', () {
      expect(bloc.state, isA<OnboardingInitial>());
    });

    group('OnboardingStarted', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'emits OnboardingComplete when onboarding was already done',
        setUp: () {
          when(() => getOnboardingComplete()).thenReturn(const Success(true));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const OnboardingStarted()),
        expect: () => [isA<OnboardingComplete>()],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'emits OnboardingInProgress with correct step for fresh start',
        setUp: () {
          when(() => getOnboardingComplete()).thenReturn(const Success(false));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const OnboardingStarted()),
        expect: () => [const OnboardingInProgress(currentStep: 0)],
      );
    });

    group('BiometricSetupCompleted', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'saves biometrics, marks onboarding complete, and cleans up steps',
        setUp: () {
          when(
            () => setBiometricsEnabled(true),
          ).thenAnswer((_) async => const Success(null));
          when(
            () => setOnboardingComplete(true),
          ).thenAnswer((_) async => const Success(null));
          when(
            () => deleteOnboardingStep(),
          ).thenAnswer((_) async => const Success(null));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const BiometricSetupCompleted(enabled: true)),
        expect: () => [isA<OnboardingComplete>()],
        verify: (_) {
          verify(() => setBiometricsEnabled(true)).called(1);
          verify(() => setOnboardingComplete(true)).called(1);
          verify(() => deleteOnboardingStep()).called(1);
        },
      );
    });

    group('OnboardingSkipped', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'marks onboarding complete and emits OnboardingComplete',
        setUp: () {
          when(
            () => setOnboardingComplete(true),
          ).thenAnswer((_) async => const Success(null));
          when(
            () => deleteOnboardingStep(),
          ).thenAnswer((_) async => const Success(null));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const OnboardingSkipped()),
        expect: () => [isA<OnboardingComplete>()],
        verify: (_) {
          verify(() => setOnboardingComplete(true)).called(1);
        },
      );
    });

    group('BiometricAuthRequested', () {
      blocTest<OnboardingBloc, OnboardingState>(
        'emits [BiometricAuthInProgress, OnboardingComplete] on success',
        setUp: () {
          when(
            () => checkBiometrics(),
          ).thenAnswer((_) async => const Success(true));
          when(
            () => authenticate(),
          ).thenAnswer((_) async => const Success(true));
          when(
            () => setBiometricsEnabled(true),
          ).thenAnswer((_) async => const Success(null));
          when(
            () => setOnboardingComplete(true),
          ).thenAnswer((_) async => const Success(null));
          when(
            () => deleteOnboardingStep(),
          ).thenAnswer((_) async => const Success(null));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const BiometricAuthRequested()),
        expect: () => [
          isA<BiometricAuthInProgress>(),
          isA<OnboardingComplete>(),
        ],
        verify: (_) {
          verify(() => checkBiometrics()).called(1);
          verify(() => authenticate()).called(1);
          verify(() => setBiometricsEnabled(true)).called(1);
          verify(() => setOnboardingComplete(true)).called(1);
        },
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'emits [BiometricAuthInProgress, BiometricAuthFailure, OnboardingInProgress] when not available',
        setUp: () {
          when(
            () => checkBiometrics(),
          ).thenAnswer((_) async => const Success(false));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const BiometricAuthRequested()),
        expect: () => [
          isA<BiometricAuthInProgress>(),
          isA<BiometricAuthFailure>(),
          const OnboardingInProgress(currentStep: 0),
        ],
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'emits [BiometricAuthInProgress, BiometricAuthFailure, OnboardingInProgress] on auth failure',
        setUp: () {
          when(
            () => checkBiometrics(),
          ).thenAnswer((_) async => const Success(true));
          when(
            () => authenticate(),
          ).thenAnswer((_) async => const Success(false));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const BiometricAuthRequested()),
        expect: () => [
          isA<BiometricAuthInProgress>(),
          isA<BiometricAuthFailure>(),
          const OnboardingInProgress(currentStep: 0),
        ],
      );
    });
  });
}
