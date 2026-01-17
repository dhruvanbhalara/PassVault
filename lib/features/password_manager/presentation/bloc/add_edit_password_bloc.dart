import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/domain/usecases/estimate_password_strength_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';

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

  AddEditPasswordBloc(
    this._generatePasswordUseCase,
    this._estimateStrengthUseCase,
    this._getSettingsUseCase,
  ) : super(const AddEditPasswordState()) {
    on<GenerateStrongPassword>(_onGenerateStrongPassword);
    on<PasswordChanged>(_onPasswordChanged);
  }

  void _onGenerateStrongPassword(
    GenerateStrongPassword event,
    Emitter<AddEditPasswordState> emit,
  ) {
    // Read generation settings using use case
    final result = _getSettingsUseCase();

    final settings = result.fold(
      (failure) => const PasswordGenerationSettings(),
      (settings) => settings,
    );

    // Generate password using use case
    final password = _generatePasswordUseCase(
      length: settings.length,
      useSpecialChars: settings.useSpecialChars,
      useNumbers: settings.useNumbers,
      useUppercase: settings.useUppercase,
      useLowercase: settings.useLowercase,
      excludeAmbiguousChars: settings.excludeAmbiguousChars,
    );

    // Calculate strength for the newly generated password
    final strength = _estimateStrengthUseCase(password);

    emit(
      state.copyWith(
        status: AddEditStatus.generated,
        generatedPassword: password,
        strength: strength,
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
}
