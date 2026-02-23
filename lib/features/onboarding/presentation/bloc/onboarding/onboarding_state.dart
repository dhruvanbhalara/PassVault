part of 'onboarding_bloc.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();
  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingInProgress extends OnboardingState {
  final int currentStep;
  const OnboardingInProgress({required this.currentStep});

  @override
  List<Object?> get props => [currentStep];
}

class OnboardingComplete extends OnboardingState {
  const OnboardingComplete();
}

class BiometricAuthInProgress extends OnboardingState {
  const BiometricAuthInProgress();
}

class BiometricAuthFailure extends OnboardingState {
  final String message;
  const BiometricAuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
