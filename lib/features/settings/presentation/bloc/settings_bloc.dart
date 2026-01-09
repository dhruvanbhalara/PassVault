import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/services/data_service.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleBiometrics extends SettingsEvent {
  final bool value;
  const ToggleBiometrics(this.value);
  @override
  List<Object> get props => [value];
}

class UpdatePasswordSettings extends SettingsEvent {
  final PasswordGenerationSettings settings;
  const UpdatePasswordSettings(this.settings);
  @override
  List<Object> get props => [settings];
}

class ExportData extends SettingsEvent {
  final bool isJson;
  const ExportData({required this.isJson});
}

class ImportData extends SettingsEvent {
  final bool isJson;
  const ImportData({required this.isJson});
}

/// Event for exporting data with password protection.
class ExportEncryptedData extends SettingsEvent {
  final String password;
  const ExportEncryptedData({required this.password});
  @override
  List<Object> get props => [password];
}

/// Event for importing password-protected data.
class ImportEncryptedData extends SettingsEvent {
  final String password;
  final String? filePath;
  const ImportEncryptedData({required this.password, this.filePath});
  @override
  List<Object> get props => [password, filePath ?? ''];
}

// States
enum SettingsStatus { initial, loading, success, failure }

enum SettingsError {
  none,
  noDataToExport,
  importFailed,
  wrongPassword,
  unknown,
}

enum SettingsSuccess { none, exportSuccess, importSuccess }

class SettingsState extends Equatable {
  final bool useBiometrics;
  final PasswordGenerationSettings passwordSettings;
  final SettingsStatus status;
  final SettingsError error;
  final SettingsSuccess success;

  const SettingsState({
    this.useBiometrics = false,
    this.passwordSettings = const PasswordGenerationSettings(),
    this.status = SettingsStatus.initial,
    this.error = SettingsError.none,
    this.success = SettingsSuccess.none,
  });

  SettingsState copyWith({
    bool? useBiometrics,
    PasswordGenerationSettings? passwordSettings,
    SettingsStatus? status,
    SettingsError? error,
    SettingsSuccess? success,
  }) {
    return SettingsState(
      useBiometrics: useBiometrics ?? this.useBiometrics,
      passwordSettings: passwordSettings ?? this.passwordSettings,
      status: status ?? this.status,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [
    useBiometrics,
    passwordSettings,
    status,
    error,
    success,
  ];
}

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepository;
  final DataService _dataService;
  final PasswordRepository _passwordRepository;

  SettingsBloc(
    this._settingsRepository,
    this._dataService,
    this._passwordRepository,
  ) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleBiometrics>(_onToggleBiometrics);
    on<UpdatePasswordSettings>(_onUpdatePasswordSettings);
    on<ExportData>(_onExportData);
    on<ImportData>(_onImportData);
    on<ExportEncryptedData>(_onExportEncryptedData);
    on<ImportEncryptedData>(_onImportEncryptedData);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final biometricsResult = _settingsRepository.getBiometricsEnabled();
    final useBiometrics = biometricsResult.fold(
      (failure) => false,
      (enabled) => enabled,
    );

    final settingsResult = _settingsRepository.getPasswordGenerationSettings();
    final passwordSettings = settingsResult.fold(
      (failure) => const PasswordGenerationSettings(),
      (settings) => settings,
    );

    emit(
      state.copyWith(
        useBiometrics: useBiometrics,
        passwordSettings: passwordSettings,
      ),
    );
  }

  Future<void> _onToggleBiometrics(
    ToggleBiometrics event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.setBiometricsEnabled(event.value);
    emit(state.copyWith(useBiometrics: event.value));
  }

  Future<void> _onUpdatePasswordSettings(
    UpdatePasswordSettings event,
    Emitter<SettingsState> emit,
  ) async {
    await _settingsRepository.savePasswordGenerationSettings(event.settings);
    emit(state.copyWith(passwordSettings: event.settings));
  }

  Future<void> _onExportData(
    ExportData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      final result = await _passwordRepository.getPasswords();
      await result.fold(
        (failure) async {
          emit(
            state.copyWith(
              status: SettingsStatus.failure,
              error: SettingsError.unknown,
            ),
          );
        },
        (passwords) async {
          if (passwords.isEmpty) {
            emit(
              state.copyWith(
                status: SettingsStatus.failure,
                error: SettingsError.noDataToExport,
              ),
            );
            return;
          }

          if (event.isJson) {
            await _dataService.exportToJson(passwords);
          } else {
            await _dataService.exportToCsv(passwords);
          }
          emit(
            state.copyWith(
              status: SettingsStatus.success,
              success: SettingsSuccess.exportSuccess,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          error: SettingsError.unknown,
        ),
      );
    }
  }

  Future<void> _onImportData(
    ImportData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: event.isJson ? ['json'] : ['csv'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        final entries = event.isJson
            ? _dataService.importFromJson(content)
            : _dataService.importFromCsv(content);

        for (var entry in entries) {
          await _passwordRepository.savePassword(entry);
        }

        emit(
          state.copyWith(
            status: SettingsStatus.success,
            success: SettingsSuccess.importSuccess,
          ),
        );
      } else {
        emit(state.copyWith(status: SettingsStatus.initial)); // Cancelled
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          error: SettingsError.importFailed,
        ),
      );
    }
  }

  /// Handles encrypted export with password protection.
  Future<void> _onExportEncryptedData(
    ExportEncryptedData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      final result = await _passwordRepository.getPasswords();
      await result.fold(
        (failure) async {
          emit(
            state.copyWith(
              status: SettingsStatus.failure,
              error: SettingsError.unknown,
            ),
          );
        },
        (passwords) async {
          if (passwords.isEmpty) {
            emit(
              state.copyWith(
                status: SettingsStatus.failure,
                error: SettingsError.noDataToExport,
              ),
            );
            return;
          }

          await _dataService.exportToEncryptedJson(passwords, event.password);
          emit(
            state.copyWith(
              status: SettingsStatus.success,
              success: SettingsSuccess.exportSuccess,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          error: SettingsError.unknown,
        ),
      );
    }
  }

  /// Handles encrypted import with password verification.
  Future<void> _onImportEncryptedData(
    ImportEncryptedData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      // File path is passed from UI after file picker
      if (event.filePath == null) {
        emit(state.copyWith(status: SettingsStatus.initial));
        return;
      }

      final file = File(event.filePath!);
      final encryptedData = await file.readAsBytes();

      final entries = _dataService.importFromEncrypted(
        Uint8List.fromList(encryptedData),
        event.password,
      );

      for (var entry in entries) {
        await _passwordRepository.savePassword(entry);
      }

      emit(
        state.copyWith(
          status: SettingsStatus.success,
          success: SettingsSuccess.importSuccess,
        ),
      );
    } on StateError {
      // Wrong password or corrupted data
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          error: SettingsError.wrongPassword,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SettingsStatus.failure,
          error: SettingsError.importFailed,
        ),
      );
    }
  }
}
