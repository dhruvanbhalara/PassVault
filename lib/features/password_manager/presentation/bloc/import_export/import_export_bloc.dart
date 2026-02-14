import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/services/data_service.dart';
import 'package:passvault/core/services/file_picker_service.dart';
import 'package:passvault/core/services/file_service.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/clear_all_passwords_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/import_passwords_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/resolve_duplicates_usecase.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_helpers.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_path_resolver.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_state.dart';

@lazySingleton
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
    on<ExportEncryptedEvent>(_onExportEncrypted);
    on<PrepareImportFromFileEvent>(_onPrepareImportFromFile);
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
          final fileName = generateExportFileName(
            'passvault_export',
            extension,
          );
          final content = event.isJson
              ? _dataService.generateJson(passwords)
              : _dataService.generateCsv(passwords);

          await _saveAndEmit(fileName, utf8.encode(content), [extension], emit);
        },
      );
    } catch (e) {
      _emitFailure(emit, message: 'Export failed', error: e);
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

          final fileName = generateExportFileName('passvault_export', 'pvault');
          final content = _dataService.generateEncryptedJson(
            passwords,
            event.password,
          );

          await _saveAndEmit(fileName, content, ['pvault'], emit);
        },
      );
    } catch (e) {
      _emitFailure(emit, message: 'Encrypted export failed', error: e);
    }
  }

  Future<void> _onImportEncrypted(
    ImportEncryptedEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading());
    try {
      final path = event.filePath ?? await _filePickerService.pickFile();
      if (path == null) return emit(const ImportExportInitial());
      await _resolveAndImport(path, emit, password: event.password);
    } catch (e) {
      _emitFailure(
        emit,
        message: 'Decryption failed',
        error: e,
        errorType: DataMigrationError.wrongPassword,
      );
    }
  }

  Future<void> _onPrepareImportFromFile(
    PrepareImportFromFileEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading());
    try {
      final path = await _filePickerService.pickFile(
        allowedExtensions: ['json', 'csv', 'pvault'],
      );
      if (path == null) {
        emit(const ImportExportInitial());
        return;
      }
      await _resolveAndImport(path, emit);
    } catch (e) {
      _emitFailure(
        emit,
        message: 'Import file selection failed',
        error: e,
        errorType: DataMigrationError.invalidFormat,
      );
    }
  }

  Future<void> _resolveAndImport(
    String path,
    Emitter<ImportExportState> emit, {
    String? password,
  }) async {
    final resolver = ImportExportPathResolver(_fileService, _dataService);
    final result = await resolver.resolve(path, password: password);

    switch (result) {
      case ImportPathEntries(:final entries):
        emit(
          await resolveImportState(
            importPasswordsUseCase: _importPasswordsUseCase,
            entries: entries,
          ),
        );
      case ImportPathRequiresPassword(:final filePath):
        emit(ImportEncryptedFileSelected(filePath));
      case ImportPathInvalidFormat():
        emit(
          const ImportExportFailure(
            DataMigrationError.invalidFormat,
            'Please select a .json, .csv, or .pvault file',
          ),
        );
    }
  }

  Future<void> _saveAndEmit(
    String fileName,
    Uint8List bytes,
    List<String> extensions,
    Emitter<ImportExportState> emit,
  ) async => emit(
    await saveExportResult(
      filePickerService: _filePickerService,
      fileName: fileName,
      bytes: bytes,
      extensions: extensions,
    ),
  );

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

  void _emitFailure(
    Emitter<ImportExportState> emit, {
    required String message,
    required Object error,
    DataMigrationError errorType = DataMigrationError.unknown,
  }) => emit(
    buildImportExportFailure(
      message: message,
      error: error,
      errorType: errorType,
    ),
  );
}
