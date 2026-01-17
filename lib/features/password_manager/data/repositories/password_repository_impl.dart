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

@LazySingleton(as: PasswordRepository)
class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordLocalDataSource _localDataSource;
  final CsvExporter _csvExporter;

  // Stream controller for broadcasting data change events
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
  Future<Result<void>> savePassword(PasswordEntry entry) async {
    try {
      final model = PasswordEntryModel.fromEntity(entry);
      await _localDataSource.savePassword(model);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deletePassword(String id) async {
    try {
      await _localDataSource.deletePassword(id);
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
      // Get existing passwords for duplicate detection
      final existingResult = await getPasswords();
      if (existingResult.isFailure) {
        AppLogger.error(
          'Failed to get existing passwords',
          tag: 'PasswordRepository',
        );
        return Error((existingResult as Error).failure);
      }

      final existing = (existingResult as Success<List<PasswordEntry>>).data;
      AppLogger.debug(
        'Found ${existing.length} existing passwords',
        tag: 'PasswordRepository',
      );
      final duplicates = <DuplicatePasswordEntry>[];
      final toImport = <PasswordEntry>[];

      // Detect duplicates by appName + username
      for (final entry in entries) {
        final duplicate = existing.firstWhere(
          (e) => e.appName == entry.appName && e.username == entry.username,
          orElse: () => entry, // Not found, so not a duplicate
        );

        if (duplicate != entry) {
          // Found a duplicate
          AppLogger.warning(
            'Duplicate found for ${entry.appName}/${entry.username}',
            tag: 'PasswordRepository',
          );
          duplicates.add(
            DuplicatePasswordEntry(
              existingEntry: duplicate,
              newEntry: entry,
              conflictReason: 'Same appName and username',
            ),
          );
        } else {
          toImport.add(entry);
        }
      }

      AppLogger.info(
        '${toImport.length} records to import, ${duplicates.length} duplicates detected',
        tag: 'PasswordRepository',
      );

      // Use bulk save for better performance instead of loop
      if (toImport.isNotEmpty) {
        final bulkSaveResult = await saveBulkPasswords(toImport);
        if (bulkSaveResult.isFailure) {
          AppLogger.error(
            'Bulk save failed during import',
            tag: 'PasswordRepository',
          );
          return Error((bulkSaveResult as Error).failure);
        }
      }

      // Note: saveBulkPasswords already emitted dataChanges event
      // No need to emit again here

      AppLogger.info(
        'Successfully imported ${toImport.length} passwords',
        tag: 'PasswordRepository',
      );

      return Success(
        ImportResult(
          totalRecords: entries.length,
          successfulImports: toImport.length,
          failedImports: 0,
          duplicateEntries: duplicates,
          errors: [],
        ),
      );
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
        switch (resolution.userChoice) {
          case DuplicateResolutionChoice.keepExisting:
            // Do nothing - keep the existing entry as is
            break;

          case DuplicateResolutionChoice.replaceWithNew:
            // Update existing entry with new data (keep same ID)
            final updated = PasswordEntry(
              id: resolution.existingEntry.id, // Keep existing ID
              appName: resolution.newEntry.appName,
              username: resolution.newEntry.username,
              password: resolution.newEntry.password,
              lastUpdated: DateTime.now(),
              url: resolution.newEntry.url,
              notes: resolution.newEntry.notes,
              folder: resolution.newEntry.folder,
              favorite: resolution.newEntry.favorite,
            );
            final result = await savePassword(updated);
            if (result.isFailure) {
              return result;
            }
            break;

          case DuplicateResolutionChoice.keepBoth:
            // Save new entry with modified appName to avoid confusion
            final modified = PasswordEntry(
              id: resolution.newEntry.id,
              appName: '${resolution.newEntry.appName} (imported)',
              username: resolution.newEntry.username,
              password: resolution.newEntry.password,
              lastUpdated: resolution.newEntry.lastUpdated,
              url: resolution.newEntry.url,
              notes: resolution.newEntry.notes,
              folder: resolution.newEntry.folder,
              favorite: resolution.newEntry.favorite,
            );
            final result = await savePassword(modified);
            if (result.isFailure) {
              return result;
            }
            break;

          case null:
            // Should not happen if validation in use case works
            return const Error(
              ImportExportFailure('Unresolved duplicate found'),
            );
        }
      }

      // Notify listeners of data change
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
      // Get all passwords
      final result = await getPasswords();

      if (result.isFailure) {
        return Error((result as Error).failure);
      }

      final passwords = (result as Success<List<PasswordEntry>>).data;

      // Export to CSV
      final csvContent = _csvExporter.export(passwords);

      return Success(csvContent);
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

      // Notify listeners of data change
      _dataChangeController.add(null);
      AppLogger.debug(
        'Bulk save completed, event emitted',
        tag: 'PasswordRepository',
      );

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

      // Notify listeners of data change
      _dataChangeController.add(null);
      AppLogger.debug(
        'Bulk delete completed, event emitted',
        tag: 'PasswordRepository',
      );

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

      // Notify listeners of data change
      _dataChangeController.add(null);
      AppLogger.info(
        'All passwords cleared, event emitted',
        tag: 'PasswordRepository',
      );

      return const Success(null);
    } catch (e) {
      AppLogger.error(
        'Failed to clear all passwords: $e',
        tag: 'PasswordRepository',
      );
      return Error(DatabaseFailure(e.toString()));
    }
  }

  /// Clean up stream controller.
  /// Called automatically by dependency injection on app termination.
  @disposeMethod
  @override
  void dispose() {
    _dataChangeController.close();
    AppLogger.debug('PasswordRepository disposed', tag: 'PasswordRepository');
  }
}
