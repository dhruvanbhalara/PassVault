import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passvault/features/generator/presentation/bloc/generator_event.dart';
import 'package:passvault/features/generator/presentation/bloc/generator_state.dart';
import 'package:passvault/features/password_manager/domain/usecases/estimate_password_strength_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/usecases/password_settings_usecases.dart';

export 'generator_event.dart';
export 'generator_state.dart';

class GeneratorBloc extends Bloc<GeneratorEvent, GeneratorState> {
  final GeneratePasswordUseCase _generatePasswordUseCase;
  final EstimatePasswordStrengthUseCase _estimatePasswordStrengthUseCase;
  final GetPasswordGenerationSettingsUseCase _getSettingsUseCase;

  GeneratorBloc(
    this._generatePasswordUseCase,
    this._estimatePasswordStrengthUseCase,
    this._getSettingsUseCase,
  ) : super(const GeneratorLoading()) {
    on<GeneratorStarted>(_onStarted);
    on<GeneratorRequested>(_onRequested);
    on<GeneratorLengthChanged>(_onLengthChanged);
    on<GeneratorUppercaseToggled>(_onUppercaseToggled);
    on<GeneratorLowercaseToggled>(_onLowercaseToggled);
    on<GeneratorNumbersToggled>(_onNumbersToggled);
    on<GeneratorSymbolsToggled>(_onSymbolsToggled);
    on<GeneratorExcludeAmbiguousToggled>(_onExcludeAmbiguousToggled);

    add(const GeneratorStarted());
  }

  void _onStarted(GeneratorStarted event, Emitter<GeneratorState> emit) {
    final settingsResult = _getSettingsUseCase();
    final settings = settingsResult.fold(
      (failure) => PasswordGenerationSettings.initial(),
      (value) => value,
    );
    emit(_buildGeneratedState(settings.defaultStrategy));
  }

  void _onRequested(GeneratorRequested event, Emitter<GeneratorState> emit) {
    if (state case GeneratorLoaded(:final strategy)) {
      emit(_buildGeneratedState(strategy));
    }
  }

  void _onLengthChanged(
    GeneratorLengthChanged event,
    Emitter<GeneratorState> emit,
  ) {
    if (state case GeneratorLoaded(:final strategy)) {
      emit(_buildGeneratedState(strategy.copyWith(length: event.length)));
    }
  }

  void _onUppercaseToggled(
    GeneratorUppercaseToggled event,
    Emitter<GeneratorState> emit,
  ) {
    if (state case GeneratorLoaded(:final strategy)) {
      emit(_buildGeneratedState(strategy.copyWith(useUppercase: event.value)));
    }
  }

  void _onLowercaseToggled(
    GeneratorLowercaseToggled event,
    Emitter<GeneratorState> emit,
  ) {
    if (state case GeneratorLoaded(:final strategy)) {
      emit(_buildGeneratedState(strategy.copyWith(useLowercase: event.value)));
    }
  }

  void _onNumbersToggled(
    GeneratorNumbersToggled event,
    Emitter<GeneratorState> emit,
  ) {
    if (state case GeneratorLoaded(:final strategy)) {
      emit(_buildGeneratedState(strategy.copyWith(useNumbers: event.value)));
    }
  }

  void _onSymbolsToggled(
    GeneratorSymbolsToggled event,
    Emitter<GeneratorState> emit,
  ) {
    if (state case GeneratorLoaded(:final strategy)) {
      emit(
        _buildGeneratedState(strategy.copyWith(useSpecialChars: event.value)),
      );
    }
  }

  void _onExcludeAmbiguousToggled(
    GeneratorExcludeAmbiguousToggled event,
    Emitter<GeneratorState> emit,
  ) {
    if (state case GeneratorLoaded(:final strategy)) {
      emit(
        _buildGeneratedState(
          strategy.copyWith(excludeAmbiguousChars: event.value),
        ),
      );
    }
  }

  GeneratorLoaded _buildGeneratedState(PasswordGenerationStrategy strategy) {
    final hasCharacterSet =
        strategy.useUppercase ||
        strategy.useLowercase ||
        strategy.useNumbers ||
        strategy.useSpecialChars;

    if (!hasCharacterSet) {
      return GeneratorLoaded(
        strategy: strategy,
        generatedPassword: '',
        strength: 0.0,
      );
    }

    final generatedPassword = _generatePasswordUseCase(
      length: strategy.length,
      useNumbers: strategy.useNumbers,
      useSpecialChars: strategy.useSpecialChars,
      useUppercase: strategy.useUppercase,
      useLowercase: strategy.useLowercase,
      excludeAmbiguousChars: strategy.excludeAmbiguousChars,
    );

    final strength = _estimatePasswordStrengthUseCase(generatedPassword);
    return GeneratorLoaded(
      strategy: strategy,
      generatedPassword: generatedPassword,
      strength: strength,
    );
  }
}
