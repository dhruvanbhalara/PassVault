import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/domain/usecases/estimate_password_strength_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/usecases/password_settings_usecases.dart';

part 'generator_event.dart';
part 'generator_state.dart';

@injectable
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
    on<GeneratorStrategySelected>(_onStrategySelected);

    add(const GeneratorStarted());
  }

  void _onStarted(GeneratorStarted event, Emitter<GeneratorState> emit) {
    final settingsResult = _getSettingsUseCase();
    final settings = settingsResult.fold(
      (failure) => PasswordGenerationSettings.initial(),
      (value) => value,
    );
    emit(_buildGeneratedState(settings.defaultStrategy, settings: settings));
  }

  void _onRequested(GeneratorRequested event, Emitter<GeneratorState> emit) {
    if (state case GeneratorLoaded(:final strategy, :final settings)) {
      emit(_buildGeneratedState(strategy, settings: settings));
    }
  }

  void _onLengthChanged(
    GeneratorLengthChanged event,
    Emitter<GeneratorState> emit,
  ) {
    if (state case GeneratorLoaded(:final strategy, :final settings)) {
      emit(
        _buildGeneratedState(
          strategy.copyWith(length: event.length),
          settings: settings,
        ),
      );
    }
  }

  void _onUppercaseToggled(
    GeneratorUppercaseToggled event,
    Emitter<GeneratorState> emit,
  ) {
    if (state case GeneratorLoaded(:final strategy, :final settings)) {
      emit(
        _buildGeneratedState(
          strategy.copyWith(useUppercase: event.value),
          settings: settings,
        ),
      );
    }
  }

  void _onLowercaseToggled(
    GeneratorLowercaseToggled event,
    Emitter<GeneratorState> emit,
  ) {
    if (state case GeneratorLoaded(:final strategy, :final settings)) {
      emit(
        _buildGeneratedState(
          strategy.copyWith(useLowercase: event.value),
          settings: settings,
        ),
      );
    }
  }

  void _onNumbersToggled(
    GeneratorNumbersToggled event,
    Emitter<GeneratorState> emit,
  ) {
    if (state case GeneratorLoaded(:final strategy, :final settings)) {
      emit(
        _buildGeneratedState(
          strategy.copyWith(useNumbers: event.value),
          settings: settings,
        ),
      );
    }
  }

  void _onSymbolsToggled(
    GeneratorSymbolsToggled event,
    Emitter<GeneratorState> emit,
  ) {
    if (state case GeneratorLoaded(:final strategy, :final settings)) {
      emit(
        _buildGeneratedState(
          strategy.copyWith(useSpecialChars: event.value),
          settings: settings,
        ),
      );
    }
  }

  void _onExcludeAmbiguousToggled(
    GeneratorExcludeAmbiguousToggled event,
    Emitter<GeneratorState> emit,
  ) {
    if (state case GeneratorLoaded(:final strategy, :final settings)) {
      emit(
        _buildGeneratedState(
          strategy.copyWith(excludeAmbiguousChars: event.value),
          settings: settings,
        ),
      );
    }
  }

  void _onStrategySelected(
    GeneratorStrategySelected event,
    Emitter<GeneratorState> emit,
  ) {
    if (state case GeneratorLoaded(:final strategy, :final settings)) {
      if (settings == null) return;
      if (strategy.id == event.strategyId) return;

      final selectedStrategy = settings.strategies.firstWhere(
        (s) => s.id == event.strategyId,
        orElse: () => settings.defaultStrategy,
      );
      emit(_buildGeneratedState(selectedStrategy, settings: settings));
    }
  }

  GeneratorLoaded _buildGeneratedState(
    PasswordGenerationStrategy strategy, {
    PasswordGenerationSettings? settings,
  }) {
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
        settings: settings,
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
      settings: settings,
    );
  }
}
