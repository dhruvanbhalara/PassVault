import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/constants/storage_keys.dart';
import 'package:passvault/core/services/database_service.dart';
import 'package:passvault/features/password_manager/domain/usecases/estimate_password_strength_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

/// Events for the [AddEditPasswordBloc].
sealed class AddEditPasswordEvent extends Equatable {
  const AddEditPasswordEvent();
  @override
  List<Object?> get props => [];
}

/// Triggered when the user wants to generate a new strong password.
final class GenerateStrongPassword extends AddEditPasswordEvent {}

/// Triggered when the password text field's value changes.
final class PasswordChanged extends AddEditPasswordEvent {
  final String password;
  const PasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

/// Status indicating the state of the password entry form.
enum AddEditStatus {
  /// The initial state or when the user is manually typing.
  initial,

  /// The state after a password has been automatically generated.
  generated,
}

/// Represents the current state of the [AddEditPasswordBloc].
class AddEditPasswordState extends Equatable {
  /// The current status of the form.
  final AddEditStatus status;

  /// The last generated password string.
  final String generatedPassword;

  /// The estimated strength of the current password (0.0 to 1.0).
  final double strength;

  const AddEditPasswordState({
    this.status = AddEditStatus.initial,
    this.generatedPassword = '',
    this.strength = 0.0,
  });

  /// Creates a copy of the state with updated values.
  AddEditPasswordState copyWith({
    AddEditStatus? status,
    String? generatedPassword,
    double? strength,
  }) {
    return AddEditPasswordState(
      status: status ?? this.status,
      generatedPassword: generatedPassword ?? this.generatedPassword,
      strength: strength ?? this.strength,
    );
  }

  @override
  List<Object?> get props => [status, generatedPassword, strength];
}

/// BLoC responsible for managing the logic of adding or editing password entries.
///
/// Handles password generation and strength estimation.
@injectable
class AddEditPasswordBloc
    extends Bloc<AddEditPasswordEvent, AddEditPasswordState> {
  final GeneratePasswordUseCase _generatePasswordUseCase;
  final EstimatePasswordStrengthUseCase _estimateStrengthUseCase;
  final DatabaseService _dbService;

  AddEditPasswordBloc(
    this._generatePasswordUseCase,
    this._estimateStrengthUseCase,
    this._dbService,
  ) : super(const AddEditPasswordState()) {
    on<GenerateStrongPassword>(_onGenerateStrongPassword);
    on<PasswordChanged>(_onPasswordChanged);
  }

  void _onGenerateStrongPassword(
    GenerateStrongPassword event,
    Emitter<AddEditPasswordState> emit,
  ) {
    // Read generation settings from database
    final passwordSettingsJson = _dbService.read(
      StorageKeys.settingsBox,
      StorageKeys.passwordSettings,
      defaultValue: null,
    );

    final settings = passwordSettingsJson != null
        ? PasswordGenerationSettings.fromJson(
            Map<String, dynamic>.from(passwordSettingsJson),
          )
        : const PasswordGenerationSettings();

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
