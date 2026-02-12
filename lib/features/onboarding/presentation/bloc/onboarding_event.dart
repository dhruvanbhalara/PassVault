import 'package:equatable/equatable.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();
  @override
  List<Object?> get props => [];
}

/// Fired on app start to check whether onboarding was already finished.
class OnboardingStarted extends OnboardingEvent {}

/// User completed or enabled biometric authentication.
class BiometricSetupCompleted extends OnboardingEvent {
  final bool enabled;
  const BiometricSetupCompleted({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// User requested biometric authentication during onboarding.
class BiometricAuthRequested extends OnboardingEvent {}

/// User tapped "Skip" on any optional onboarding step.
class OnboardingSkipped extends OnboardingEvent {}

/// Legacy / direct completion (e.g. from tests or admin actions).
class OnboardingCompleted extends OnboardingEvent {}
