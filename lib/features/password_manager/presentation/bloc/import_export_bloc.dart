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
    emit(const ImportExportLoading('Preparing export...'));
    try {
      final result = await _passwordRepository.getPasswords();
      await result.fold(
        (failure) async {
          emit(
            ImportExportFailure(DataMigrationError.unknown, failure.message),
          );
        },
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

          final timestamp = DateTime.now()
              .toIso8601String()
              .replaceAll(':', '-')
              .split('.')
              .first;
          final fileName =
              'passvault_export_$timestamp.${event.isJson ? 'json' : 'csv'}';

          final content = event.isJson
              ? _dataService.generateJson(passwords)
              : _dataService.generateCsv(passwords);
          final bytes = utf8.encode(content);

          final destinationPath = await _filePickerService.pickSavePath(
            fileName: fileName,
            bytes: bytes,
            allowedExtensions: [event.isJson ? 'json' : 'csv'],
          );

          if (destinationPath == null) {
            emit(const ImportExportInitial()); // Cancelled
            return;
          }

          emit(ExportSuccess(destinationPath));
        },
      );
    } catch (e) {
      AppLogger.error('Export failed', tag: 'ImportExportBloc', error: e);
      emit(ImportExportFailure(DataMigrationError.unknown, e.toString()));
    }
  }

  Future<void> _onImportData(
    ImportDataEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading('Reading file...'));
    try {
      final path = await _filePickerService.pickFile(
        allowedExtensions: event.isJson ? ['json'] : ['csv'],
      );

      if (path == null) {
        emit(const ImportExportInitial()); // Cancelled
        return;
      }

      final content = await _fileService.readAsString(path);
      final entries = event.isJson
          ? _dataService.importFromJson(content)
          : _dataService.importFromCsv(content);

      emit(const ImportExportLoading('Importing passwords...'));
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
    } catch (e) {
      AppLogger.error('Import failed', tag: 'ImportExportBloc', error: e);
      emit(ImportExportFailure(DataMigrationError.invalidFormat, e.toString()));
    }
  }

  Future<void> _onExportEncrypted(
    ExportEncryptedEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading('Encrypting data...'));
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

          final timestamp = DateTime.now()
              .toIso8601String()
              .replaceAll(':', '-')
              .split('.')
              .first;
          final fileName = 'passvault_export_$timestamp.pvault';

          final content = _dataService.generateEncryptedJson(
            passwords,
            event.password,
          );

          final destinationPath = await _filePickerService.pickSavePath(
            fileName: fileName,
            bytes: content,
            allowedExtensions: ['pvault'],
          );

          if (destinationPath == null) {
            emit(const ImportExportInitial());
            return;
          }

          emit(ExportSuccess(destinationPath));
        },
      );
    } catch (e) {
      AppLogger.error(
        'Encrypted export failed',
        tag: 'ImportExportBloc',
        error: e,
      );
      emit(ImportExportFailure(DataMigrationError.unknown, e.toString()));
    }
  }

  Future<void> _onImportEncrypted(
    ImportEncryptedEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading('Decrypting data...'));

    final path =
        event.filePath ??
        await _filePickerService.pickFile(allowedExtensions: ['pvault']);

    if (path == null) {
      emit(const ImportExportInitial());
      return;
    }

    final encryptedData = await _fileService.readAsBytes(path);

    final List<PasswordEntry> entries;
    try {
      entries = _dataService.importFromEncrypted(
        Uint8List.fromList(encryptedData),
        event.password,
      );
    } catch (e) {
      AppLogger.error('Decryption failed', tag: 'ImportExportBloc', error: e);
      emit(
        const ImportExportFailure(
          DataMigrationError.wrongPassword,
          'Incorrect password or corrupted file',
        ),
      );
      return;
    }

    emit(const ImportExportLoading('Importing passwords...'));
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

  Future<void> _onResolveDuplicates(
    ResolveDuplicatesEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading('Resolving duplicates...'));
    try {
      final result = await _resolveDuplicatesUseCase(event.resolutions);
      result.fold(
        (failure) => emit(
          ImportExportFailure(DataMigrationError.unknown, failure.message),
        ),
        (_) {
          final count = event.resolutions.length;
          emit(DuplicatesResolved(totalResolved: count, totalImported: count));
        },
      );
    } catch (e) {
      emit(ImportExportFailure(DataMigrationError.unknown, e.toString()));
    }
  }

  Future<void> _onClearDatabase(
    ClearDatabaseEvent event,
    Emitter<ImportExportState> emit,
  ) async {
    emit(const ImportExportLoading('Clearing data...'));

    AppLogger.info('Starting bulk clear operation', tag: 'ImportExportBloc');

    final result = await _clearAllPasswordsUseCase();

    result.fold(
      (failure) {
        AppLogger.error(
          'Failed to clear database: ${failure.message}',
          tag: 'ImportExportBloc',
        );
        emit(ImportExportFailure(DataMigrationError.unknown, failure.message));
      },
      (_) {
        AppLogger.info(
          'Database cleared successfully',
          tag: 'ImportExportBloc',
        );
        // Stream event will be automatically emitted by repository
        emit(const ClearDatabaseSuccess());
      },
    );
  }

  void _onResetMigrationStatus(
    ResetMigrationStatus event,
    Emitter<ImportExportState> emit,
  ) {
    emit(const ImportExportInitial());
  }
}
