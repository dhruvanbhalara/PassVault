import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:passvault/features/settings/domain/usecases/onboarding_usecases.dart';

export 'onboarding_event.dart';
export 'onboarding_state.dart';

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
