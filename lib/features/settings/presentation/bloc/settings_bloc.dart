import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/constants/storage_keys.dart';
import 'package:passvault/core/services/data_service.dart';
import 'package:passvault/core/services/database_service.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

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

// States
enum SettingsStatus { initial, loading, success, failure }

enum SettingsError { none, noDataToExport, importFailed, unknown }

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
  final DatabaseService _dbService;
  final DataService _dataService;
  final PasswordRepository _passwordRepository;

  SettingsBloc(this._dbService, this._dataService, this._passwordRepository)
    : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleBiometrics>(_onToggleBiometrics);
    on<UpdatePasswordSettings>(_onUpdatePasswordSettings);
    on<ExportData>(_onExportData);
    on<ImportData>(_onImportData);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    final useBiometrics = _dbService.read(
      StorageKeys.settingsBox,
      StorageKeys.useBiometrics,
      defaultValue: false,
    );

    final passwordSettingsJson = _dbService.read(
      StorageKeys.settingsBox,
      StorageKeys.passwordSettings,
      defaultValue: null,
    );

    final passwordSettings = passwordSettingsJson != null
        ? PasswordGenerationSettings.fromJson(
            Map<String, dynamic>.from(passwordSettingsJson),
          )
        : const PasswordGenerationSettings();

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
    await _dbService.write(
      StorageKeys.settingsBox,
      StorageKeys.useBiometrics,
      event.value,
    );
    emit(state.copyWith(useBiometrics: event.value));
  }

  Future<void> _onUpdatePasswordSettings(
    UpdatePasswordSettings event,
    Emitter<SettingsState> emit,
  ) async {
    await _dbService.write(
      StorageKeys.settingsBox,
      StorageKeys.passwordSettings,
      event.settings.toJson(),
    );
    emit(state.copyWith(passwordSettings: event.settings));
  }

  Future<void> _onExportData(
    ExportData event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      final passwords = await _passwordRepository.getPasswords();
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
}
