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
  ) : super(const AddEditPasswordState()) {
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
      (settings) => emit(state.copyWith(settings: settings)),
    );
  }

  void _onGenerateStrongPassword(
    GenerateStrongPassword event,
    Emitter<AddEditPasswordState> emit,
  ) {
    if (state.settings == null) {
      // Fallback if settings haven't loaded yet?
      // Or re-fetch.
      // For simplicity let's re-use the fetched settings or fetch now.
    }

    // We can rely on state.settings being populated, OR better yet, fetch fresh settings
    // to ensure we have the latest.
    final result = _getSettingsUseCase();

    final settings = result.fold(
      (failure) => PasswordGenerationSettings.initial(),
      (settings) => settings,
    );

    // Update state with fresh settings
    // We emit later, so just use local var for calculation.

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
      state.copyWith(
        status: AddEditStatus.generated,
        generatedPassword: password,
        strength: strength,
        settings: settings, // Update settings in state
      ),
    );
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<AddEditPasswordState> emit,
  ) {
    // Re-calculate strength as user types
    final strength = _estimateStrengthUseCase(event.password);

    // Reset status to initial so the UI listener knows this isn't an auto-generation.
    // This allows the user to manually edit without the listener overwriting their text.
    emit(state.copyWith(status: AddEditStatus.initial, strength: strength));
  }

  Future<void> _onSaveEntry(
    SaveEntry event,
    Emitter<AddEditPasswordState> emit,
  ) async {
    emit(state.copyWith(status: AddEditStatus.saving));

    final result = await _savePasswordUseCase(event.entry);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AddEditStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: AddEditStatus.success)),
    );
  }
}
