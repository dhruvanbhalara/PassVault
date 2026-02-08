import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/services/data_service.dart';
import 'package:passvault/core/services/file_picker_service.dart';
import 'package:passvault/core/services/file_service.dart';
import 'package:passvault/core/utils/app_logger.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/clear_all_passwords_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/import_passwords_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/resolve_duplicates_usecase.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';

@injectable
class ImportExportBloc extends Bloc<ImportExportEvent, ImportExportState> {
  final ImportPasswordsUseCase _importPasswordsUseCase;
  final ResolveDuplicatesUseCase _resolveDuplicatesUseCase;
  final ClearAllPasswordsUseCase _clearAllPasswordsUseCase;
  final PasswordRepository _passwordRepository;
  final DataService _dataService;
  final FileService _fileService;
  final IFilePickerService _filePickerService;

  ImportExportBloc(
    this._importPasswordsUseCase,
    this._resolveDuplicatesUseCase,
    this._clearAllPasswordsUseCase,
    this._passwordRepository,
    this._dataService,
    this._fileService,
    this._filePickerService,
  ) : super(const ImportExportInitial()) {
    on<ExportDataEvent>(_onExportData);
    on<ImportDataEvent>(_onImportData);
    on<ExportEncryptedEvent>(_onExportEncrypted);
    on<ImportEncryptedEvent>(_onImportEncrypted);
    on<ResolveDuplicatesEvent>(_onResolveDuplicates);
    on<ClearDatabaseEvent>(_onClearDatabase);
    on<ResetMigrationStatus>(_onResetMigrationStatus);
  }

  Future<void> _onExportData(
    ExportDataEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading());
    try {
      final result = await _passwordRepository.getPasswords();
      await result.fold(
        (failure) async => emit(
          ImportExportFailure(DataMigrationError.unknown, failure.message),
        ),
        (passwords) async {
          if (passwords.isEmpty) {
            emit(
              const ImportExportFailure(
                DataMigrationError.noDataToExport,
                'No passwords found to export',
              ),
            );
            return;
          }

          final extension = event.isJson ? 'json' : 'csv';
          final fileName = _generateFileName('passvault_export', extension);
          final content = event.isJson
              ? _dataService.generateJson(passwords)
              : _dataService.generateCsv(passwords);

          await _saveAndEmit(fileName, utf8.encode(content), [extension], emit);
        },
      );
    } catch (e) {
      _handleError('Export failed', e, emit);
    }
  }

  Future<void> _onImportData(
    ImportDataEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading());
    try {
      final path = await _filePickerService.pickFile(
        allowedExtensions: event.isJson ? ['json'] : ['csv'],
      );
      if (path == null) return emit(const ImportExportInitial());

      final content = await _fileService.readAsString(path);
      final entries = event.isJson
          ? _dataService.importFromJson(content)
          : _dataService.importFromCsv(content);

      await _executeImport(entries, emit);
    } catch (e) {
      _handleError(
        'Import failed',
        e,
        emit,
        errorType: DataMigrationError.invalidFormat,
      );
    }
  }

  Future<void> _onExportEncrypted(
    ExportEncryptedEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading());
    try {
      final result = await _passwordRepository.getPasswords();
      await result.fold(
        (failure) async => emit(
          ImportExportFailure(DataMigrationError.unknown, failure.message),
        ),
        (passwords) async {
          if (passwords.isEmpty) {
            emit(
              const ImportExportFailure(
                DataMigrationError.noDataToExport,
                'No passwords found to export',
              ),
            );
            return;
          }

          final fileName = _generateFileName('passvault_export', 'pvault');
          final content = _dataService.generateEncryptedJson(
            passwords,
            event.password,
          );

          await _saveAndEmit(fileName, content, ['pvault'], emit);
        },
      );
    } catch (e) {
      _handleError('Encrypted export failed', e, emit);
    }
  }

  Future<void> _onImportEncrypted(
    ImportEncryptedEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading());
    try {
      final path =
          event.filePath ??
          await _filePickerService.pickFile(allowedExtensions: ['pvault']);
      if (path == null) return emit(const ImportExportInitial());

      final encryptedData = await _fileService.readAsBytes(path);
      final entries = _dataService.importFromEncrypted(
        Uint8List.fromList(encryptedData),
        event.password,
      );

      await _executeImport(entries, emit);
    } catch (e) {
      _handleError(
        'Decryption failed',
        e,
        emit,
        errorType: DataMigrationError.wrongPassword,
      );
    }
  }

  Future<void> _executeImport(
    List<PasswordEntry> entries,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading());
    final result = await _importPasswordsUseCase(entries);
    result.fold(
      (failure) => emit(
        ImportExportFailure(DataMigrationError.importFailed, failure.message),
      ),
      (importResult) {
        if (importResult.hasDuplicates) {
          emit(
            DuplicatesDetected(
              duplicates: importResult.duplicateEntries,
              successfulImports: importResult.successfulImports,
            ),
          );
        } else {
          emit(ImportSuccess(importResult.successfulImports));
        }
      },
    );
  }

  Future<void> _saveAndEmit(
    String fileName,
    Uint8List bytes,
    List<String> extensions,
    Emitter<ImportExportState> emit,
  ) async {
    final destinationPath = await _filePickerService.pickSavePath(
      fileName: fileName,
      bytes: bytes,
      allowedExtensions: extensions,
    );
    if (destinationPath == null) {
      emit(const ImportExportInitial());
    } else {
      emit(ExportSuccess(destinationPath));
    }
  }

  String _generateFileName(String prefix, String extension) {
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    return '${prefix}_$timestamp.$extension';
  }

  void _handleError(
    String message,
    dynamic error,
    Emitter<ImportExportState> emit, {
    DataMigrationError errorType = DataMigrationError.unknown,
  }) {
    AppLogger.error(message, tag: 'ImportExportBloc', error: error);
    emit(ImportExportFailure(errorType, error.toString()));
  }

  Future<void> _onResolveDuplicates(
    ResolveDuplicatesEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading());
    final result = await _resolveDuplicatesUseCase(event.resolutions);
    result.fold(
      (failure) => emit(
        ImportExportFailure(DataMigrationError.unknown, failure.message),
      ),
      (_) => emit(
        DuplicatesResolved(
          totalResolved: event.resolutions.length,
          totalImported: event.resolutions.length,
        ),
      ),
    );
  }

  Future<void> _onClearDatabase(
    ClearDatabaseEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading());
    final result = await _clearAllPasswordsUseCase();
    result.fold(
      (failure) => emit(
        ImportExportFailure(DataMigrationError.unknown, failure.message),
      ),
      (_) => emit(const ClearDatabaseSuccess()),
    );
  }

  void _onResetMigrationStatus(
    ResetMigrationStatus event,
    Emitter<ImportExportState> emit,
  ) => emit(const ImportExportInitial());
}
