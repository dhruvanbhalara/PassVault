part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();
  @override
  List<Object?> get props => [];
}

class OnboardingStarted extends OnboardingEvent {
  const OnboardingStarted();
}

class OnboardingSkipped extends OnboardingEvent {
  const OnboardingSkipped();
}

class BiometricSetupCompleted extends OnboardingEvent {
  final bool enabled;
  const BiometricSetupCompleted({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class BiometricAuthRequested extends OnboardingEvent {
  const BiometricAuthRequested();
}
