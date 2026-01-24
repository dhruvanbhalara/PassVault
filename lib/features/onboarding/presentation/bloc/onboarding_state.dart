import 'package:equatable/equatable.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();
  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingSuccess extends OnboardingState {}
