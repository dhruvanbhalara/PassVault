import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/settings/domain/usecases/onboarding_usecases.dart';

// Events
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
  @override
  List<Object> get props => [];
}

class CompleteOnboarding extends OnboardingEvent {}

// States
sealed class OnboardingState extends Equatable {
  const OnboardingState();
  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingSuccess extends OnboardingState {}

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final SetOnboardingCompleteUseCase _setOnboardingCompleteUseCase;

  OnboardingBloc(this._setOnboardingCompleteUseCase)
    : super(OnboardingInitial()) {
    on<CompleteOnboarding>((event, emit) async {
      await _setOnboardingCompleteUseCase(true);
      emit(OnboardingSuccess());
    });
  }
}
