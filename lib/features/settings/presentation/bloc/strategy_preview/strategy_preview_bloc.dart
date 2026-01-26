import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/presentation/bloc/strategy_preview/strategy_preview_event.dart';
import 'package:passvault/features/settings/presentation/bloc/strategy_preview/strategy_preview_state.dart';

export 'strategy_preview_event.dart';
export 'strategy_preview_state.dart';

/// Bloc responsible for generating password previews based on strategy settings.
///
/// This Bloc handles the [GeneratePreview] event and uses [GeneratePasswordUseCase]
/// to produce a password sample according to the provided strategy configuration.
@injectable
class StrategyPreviewBloc
    extends Bloc<StrategyPreviewEvent, StrategyPreviewState> {
  final GeneratePasswordUseCase _generatePasswordUseCase;

  StrategyPreviewBloc(this._generatePasswordUseCase)
    : super(StrategyPreviewState.initial()) {
    on<GeneratePreview>(_onGeneratePreview);
  }

  void _onGeneratePreview(
    GeneratePreview event,
    Emitter<StrategyPreviewState> emit,
  ) {
    emit(state.copyWith(status: StrategyPreviewStatus.loading));

    var safeSettings = event.settings;
    if (!event.settings.useUppercase &&
        !event.settings.useNumbers &&
        !event.settings.useSpecialChars &&
        !event.settings.useLowercase) {
      safeSettings = safeSettings.copyWith(useLowercase: true);
    }

    try {
      final password = _generatePasswordUseCase(
        length: safeSettings.length,
        useNumbers: safeSettings.useNumbers,
        useSpecialChars: safeSettings.useSpecialChars,
        useUppercase: safeSettings.useUppercase,
        useLowercase: safeSettings.useLowercase,
        excludeAmbiguousChars: safeSettings.excludeAmbiguousChars,
      );
      emit(
        state.copyWith(
          status: StrategyPreviewStatus.success,
          password: password,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: StrategyPreviewStatus.failure,
          errorMessage: 'error_generating_password',
        ),
      );
    }
  }
}
