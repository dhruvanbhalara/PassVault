import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/auth/domain/usecases/authenticate_usecase.dart';
import 'package:passvault/features/auth/domain/usecases/check_biometrics_usecase.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:passvault/features/settings/domain/usecases/biometrics_usecases.dart';
import 'package:passvault/features/settings/domain/usecases/onboarding_usecases.dart';

export 'onboarding_event.dart';
export 'onboarding_state.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingCompleteUseCase _getOnboardingCompleteUseCase;
  final SetOnboardingCompleteUseCase _setOnboardingCompleteUseCase;
  final SetBiometricsEnabledUseCase _setBiometricsEnabledUseCase;
  final CheckBiometricsUseCase _checkBiometricsUseCase;
  final AuthenticateUseCase _authenticateUseCase;
  final DeleteOnboardingStepUseCase _deleteOnboardingStepUseCase;

  OnboardingBloc(
    this._getOnboardingCompleteUseCase,
    this._setOnboardingCompleteUseCase,
    this._setBiometricsEnabledUseCase,
    this._checkBiometricsUseCase,
    this._authenticateUseCase,
    this._deleteOnboardingStepUseCase,
  ) : super(OnboardingInitial()) {
    on<OnboardingStarted>(_onStarted);
    on<BiometricSetupCompleted>(_onBiometricSetupCompleted);
    on<BiometricAuthRequested>(_onBiometricAuthRequested);
    on<OnboardingSkipped>(_onSkipped);
    on<OnboardingCompleted>(_onCompleted);
  }

  /// Check persisted state and either resume or mark complete.
  Future<void> _onStarted(
    OnboardingStarted event,
    Emitter<OnboardingState> emit,
  ) async {
    final result = _getOnboardingCompleteUseCase();
    final isComplete = result.fold((_) => false, (data) => data);

    if (isComplete) {
      emit(OnboardingComplete());
      return;
    }

    emit(const OnboardingInProgress(currentStep: 0));
  }

  /// Handles the end-to-end biometric authentication flow.
  Future<void> _onBiometricAuthRequested(
    BiometricAuthRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(BiometricAuthInProgress());

    // 1. Check availability
    final availableResult = await _checkBiometricsUseCase();
    final isAvailable = availableResult.fold((_) => false, (data) => data);

    if (!isAvailable) {
      emit(
        const BiometricAuthFailure('Biometrics not supported on this device'),
      );
      emit(const OnboardingInProgress(currentStep: 0)); // Return to slide
      return;
    }

    // 2. Perform authentication
    final authResult = await _authenticateUseCase();

    await authResult.fold(
      (failure) async {
        emit(BiometricAuthFailure(failure.message));
        emit(const OnboardingInProgress(currentStep: 0));
      },
      (authenticated) async {
        if (authenticated) {
          // 3. Persist and Complete
          await _setBiometricsEnabledUseCase(true);
          await _markOnboardingComplete();
          emit(OnboardingComplete());
        } else {
          emit(const BiometricAuthFailure('Authentication failed'));
          emit(const OnboardingInProgress(currentStep: 0));
        }
      },
    );
  }

  /// Persist biometric preference and finish onboarding.
  Future<void> _onBiometricSetupCompleted(
    BiometricSetupCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    await _setBiometricsEnabledUseCase(event.enabled);
    await _markOnboardingComplete();
    emit(OnboardingComplete());
  }

  /// Skip finishes onboarding immediately.
  Future<void> _onSkipped(
    OnboardingSkipped event,
    Emitter<OnboardingState> emit,
  ) async {
    await _markOnboardingComplete();
    emit(OnboardingComplete());
  }

  /// Direct completion (legacy / programmatic).
  Future<void> _onCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    await _markOnboardingComplete();
    emit(OnboardingComplete());
  }

  Future<void> _markOnboardingComplete() async {
    await _setOnboardingCompleteUseCase(true);
    // Clean up transient step tracker.
    await _deleteOnboardingStepUseCase();
  }
}
