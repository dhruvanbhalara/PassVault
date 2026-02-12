import 'package:equatable/equatable.dart';

/// States for the onboarding state machine.
///
/// Progression: OnboardingInitial → OnboardingInProgress(step 0..2)
///              → OnboardingComplete.
sealed class OnboardingState extends Equatable {
  const OnboardingState();
  @override
  List<Object?> get props => [];
}

/// Bloc has not yet determined onboarding status.
class OnboardingInitial extends OnboardingState {}

/// Onboarding is in progress.
class OnboardingInProgress extends OnboardingState {
  final int currentStep;

  const OnboardingInProgress({this.currentStep = 0});

  @override
  List<Object?> get props => [currentStep];
}

/// Biometric authentication is being performed.
class BiometricAuthInProgress extends OnboardingState {}

/// Biometric authentication failed with an error.
class BiometricAuthFailure extends OnboardingState {
  final String message;
  const BiometricAuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Onboarding has been fully completed — user may proceed to the main app.
class OnboardingComplete extends OnboardingState {}
