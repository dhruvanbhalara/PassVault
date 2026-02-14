import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/core/utils/app_logger.dart';
import 'package:passvault/features/password_manager/data/datasources/password_local_data_source.dart';
import 'package:passvault/features/password_manager/data/exporters/csv_exporter.dart';
import 'package:passvault/features/password_manager/data/models/password_entry_model.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/domain/entities/import_result.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';

import 'password_import_helper.dart';

@LazySingleton(as: PasswordRepository)
class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordLocalDataSource _localDataSource;
  final CsvExporter _csvExporter;
  final _dataChangeController = StreamController<void>.broadcast();

  PasswordRepositoryImpl(this._localDataSource, this._csvExporter);

  @override
  Future<Result<List<PasswordEntry>>> getPasswords() async {
    try {
      final models = await _localDataSource.getPasswords();
      return Success(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<PasswordEntry?>> getPassword(String id) async {
    try {
      final model = await _localDataSource.getPassword(id);
      return Success(model?.toEntity());
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> savePassword(PasswordEntry entry) async {
    try {
      final model = PasswordEntryModel.fromEntity(entry);
      await _localDataSource.savePassword(model);
      _dataChangeController.add(null);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deletePassword(String id) async {
    try {
      await _localDataSource.deletePassword(id);
      _dataChangeController.add(null);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<ImportResult>> importPasswords(
    List<PasswordEntry> entries,
  ) async {
    AppLogger.info(
      'Starting import of ${entries.length} entries',
      tag: 'PasswordRepository',
    );
    try {
      final existingResult = await getPasswords();
      if (existingResult.isFailure) {
        return Error((existingResult as Error).failure);
      }

      final existing = (existingResult as Success<List<PasswordEntry>>).data;
      final importResult = PasswordImportHelper.detectDuplicates(
        entries,
        existing,
      );
      final toImport = PasswordImportHelper.getUniqueEntriesToImport(
        importResult,
        entries,
      );

      if (toImport.isNotEmpty) {
        final bulkSaveResult = await saveBulkPasswords(toImport);
        if (bulkSaveResult.isFailure) {
          return Error((bulkSaveResult as Error).failure);
        }
      }

      AppLogger.info(
        'Successfully imported ${toImport.length} passwords',
        tag: 'PasswordRepository',
      );
      return Success(importResult);
    } catch (e) {
      AppLogger.error('Exception during import: $e', tag: 'PasswordRepository');
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> resolveDuplicates(
    List<DuplicatePasswordEntry> resolutions,
  ) async {
    try {
      for (final resolution in resolutions) {
        if (resolution.userChoice == DuplicateResolutionChoice.keepExisting) {
          continue;
        }
        if (resolution.userChoice == null) {
          return const Error(
            DataMigrationFailure('Unresolved duplicate found'),
          );
        }

        final updated = PasswordImportHelper.resolveDuplicate(resolution);
        final result = await savePassword(updated);
        if (result.isFailure) {
          return result;
        }
      }

      _dataChangeController.add(null);
      AppLogger.debug(
        'Data change event emitted after duplicate resolution',
        tag: 'PasswordRepository',
      );
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<String>> exportPasswords({String format = 'csv'}) async {
    try {
      final result = await getPasswords();
      if (result.isFailure) return Error((result as Error).failure);

      final passwords = (result as Success<List<PasswordEntry>>).data;
      return Success(_csvExporter.export(passwords));
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<void> get dataChanges => _dataChangeController.stream;

  @override
  Future<Result<void>> saveBulkPasswords(List<PasswordEntry> entries) async {
    try {
      AppLogger.info(
        'Bulk saving ${entries.length} passwords',
        tag: 'PasswordRepository',
      );
      final models = entries
          .map((e) => PasswordEntryModel.fromEntity(e))
          .toList();
      await _localDataSource.savePasswordsBulk(models);
      _dataChangeController.add(null);
      return const Success(null);
    } catch (e) {
      AppLogger.error(
        'Failed to bulk save passwords: $e',
        tag: 'PasswordRepository',
      );
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteBulkPasswords(List<String> ids) async {
    try {
      AppLogger.info(
        'Bulk deleting ${ids.length} passwords',
        tag: 'PasswordRepository',
      );
      await _localDataSource.deletePasswordsBulk(ids);
      _dataChangeController.add(null);
      return const Success(null);
    } catch (e) {
      AppLogger.error(
        'Failed to bulk delete passwords: $e',
        tag: 'PasswordRepository',
      );
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> clearAllPasswords() async {
    try {
      AppLogger.info('Clearing all passwords', tag: 'PasswordRepository');
      await _localDataSource.clearAllPasswords();
      _dataChangeController.add(null);
      return const Success(null);
    } catch (e) {
      AppLogger.error(
        'Failed to clear all passwords: $e',
        tag: 'PasswordRepository',
      );
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @disposeMethod
  @override
  void dispose() {
    _dataChangeController.close();
    AppLogger.debug('PasswordRepository disposed', tag: 'PasswordRepository');
  }
}
