import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/constants/storage_keys.dart';
import 'package:passvault/core/services/database_service.dart';
import 'package:passvault/features/password_manager/domain/usecases/estimate_password_strength_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

// Events
abstract class AddEditPasswordEvent extends Equatable {
  const AddEditPasswordEvent();
  @override
  List<Object> get props => [];
}

class GenerateStrongPassword extends AddEditPasswordEvent {}

class PasswordChanged extends AddEditPasswordEvent {
  final String password;
  const PasswordChanged(this.password);
  @override
  List<Object> get props => [password];
}

// States
enum AddEditStatus { initial, generated }

class AddEditPasswordState extends Equatable {
  final AddEditStatus status;
  final String generatedPassword;
  final double strength;

  const AddEditPasswordState({
    this.status = AddEditStatus.initial,
    this.generatedPassword = '',
    this.strength = 0.0,
  });

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
  List<Object> get props => [status, generatedPassword, strength];
}

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
    // Read settings
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

    final password = _generatePasswordUseCase(
      length: settings.length,
      useSpecialChars: settings.useSpecialChars,
      useNumbers: settings.useNumbers,
      useUppercase: settings.useUppercase,
      useLowercase: settings.useLowercase,
      excludeAmbiguousChars: settings.excludeAmbiguousChars,
    );

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
    final strength = _estimateStrengthUseCase(event.password);
    // Reset status to initial so that listener doesn't override user's manual input
    emit(state.copyWith(status: AddEditStatus.initial, strength: strength));
  }
}
