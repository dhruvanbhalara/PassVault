import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/domain/usecases/estimate_password_strength_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/password_usecases.dart';

/// Events for the [AddEditPasswordBloc].
import 'package:passvault/features/password_manager/presentation/bloc/add_edit_password_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/add_edit_password_state.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/usecases/password_settings_usecases.dart';

export 'add_edit_password_event.dart';
export 'add_edit_password_state.dart';

/// BLoC responsible for managing the logic of adding or editing password entries.
///
/// Handles password generation and strength estimation.
@injectable
class AddEditPasswordBloc
    extends Bloc<AddEditPasswordEvent, AddEditPasswordState> {
  final GeneratePasswordUseCase _generatePasswordUseCase;
  final EstimatePasswordStrengthUseCase _estimateStrengthUseCase;
  final GetPasswordGenerationSettingsUseCase _getSettingsUseCase;
  final SavePasswordUseCase _savePasswordUseCase;

  AddEditPasswordBloc(
    this._generatePasswordUseCase,
    this._estimateStrengthUseCase,
    this._getSettingsUseCase,
    this._savePasswordUseCase,
  ) : super(const AddEditInitial()) {
    on<GenerateStrongPassword>(_onGenerateStrongPassword);
    on<PasswordChanged>(_onPasswordChanged);
    on<SaveEntry>(_onSaveEntry);
    on<LoadGenerationSettings>(_onLoadGenerationSettings);

    add(LoadGenerationSettings());
  }

  Future<void> _onLoadGenerationSettings(
    LoadGenerationSettings event,
    Emitter<AddEditPasswordState> emit,
  ) async {
    final result = _getSettingsUseCase();
    result.fold(
      (failure) => null,
      (settings) => emit(
        AddEditInitial(
          generatedPassword: state.generatedPassword,
          strength: state.strength,
          settings: settings,
        ),
      ),
    );
  }

  void _onGenerateStrongPassword(
    GenerateStrongPassword event,
    Emitter<AddEditPasswordState> emit,
  ) {
    final result = _getSettingsUseCase();
    final settings = result.fold(
      (failure) => PasswordGenerationSettings.initial(),
      (settings) => settings,
    );

    // Determine strategy
    PasswordGenerationStrategy strategy;
    if (event.strategyId != null) {
      strategy = settings.strategies.firstWhere(
        (s) => s.id == event.strategyId,
        orElse: () => settings.defaultStrategy,
      );
    } else {
      strategy = settings.defaultStrategy;
    }

    // Generate password using use case
    final password = _generatePasswordUseCase(
      length: strategy.length,
      useSpecialChars: strategy.useSpecialChars,
      useNumbers: strategy.useNumbers,
      useUppercase: strategy.useUppercase,
      useLowercase: strategy.useLowercase,
      excludeAmbiguousChars: strategy.excludeAmbiguousChars,
    );

    // Calculate strength for the newly generated password
    final strength = _estimateStrengthUseCase(password);

    emit(
      AddEditGenerated(
        generatedPassword: password,
        strength: strength,
        settings: settings,
      ),
    );
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<AddEditPasswordState> emit,
  ) {
    // Re-calculate strength as user types
    final strength = _estimateStrengthUseCase(event.password);

    emit(
      AddEditInitial(
        generatedPassword: state.generatedPassword,
        strength: strength,
        settings: state.settings,
      ),
    );
  }

  Future<void> _onSaveEntry(
    SaveEntry event,
    Emitter<AddEditPasswordState> emit,
  ) async {
    emit(
      AddEditSaving(
        generatedPassword: state.generatedPassword,
        strength: state.strength,
        settings: state.settings,
      ),
    );

    final result = await _savePasswordUseCase(event.entry);

    result.fold(
      (failure) => emit(
        AddEditFailure(
          errorMessage: failure.message,
          generatedPassword: state.generatedPassword,
          strength: state.strength,
          settings: state.settings,
        ),
      ),
      (_) => emit(
        AddEditSuccess(
          generatedPassword: state.generatedPassword,
          strength: state.strength,
          settings: state.settings,
        ),
      ),
    );
  }
}
