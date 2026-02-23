import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/utils/app_logger.dart';
import 'package:passvault/features/password_manager/data/models/password_entry_model.dart';

/// Abstract interface for local password data operations.
abstract class PasswordLocalDataSource {
  /// Retrieves all stored password entries.
  Future<List<PasswordEntryModel>> getPasswords();

  /// Retrieves a specific password entry by its ID.
  Future<PasswordEntryModel?> getPassword(String id);

  /// Saves a password entry to local storage.
  Future<void> savePassword(PasswordEntryModel entry);

  /// Deletes a password entry by its ID.
  Future<void> deletePassword(String id);

  /// Bulk operations for performance optimization

  /// Saves multiple password entries in a single transaction.
  /// Uses Hive's putAll() for atomic batch operation.
  Future<void> savePasswordsBulk(List<PasswordEntryModel> entries);

  /// Deletes multiple password entries by their IDs in a single transaction.
  /// Uses Hive's deleteAll() for atomic batch operation.
  Future<void> deletePasswordsBulk(List<String> ids);

  /// Clears all password entries from storage.
  /// Uses Hive's clear() method - fastest way to remove all data.
  Future<void> clearAllPasswords();
}

/// Implementation of [PasswordLocalDataSource] using Hive.
@LazySingleton(as: PasswordLocalDataSource)
class PasswordLocalDataSourceImpl implements PasswordLocalDataSource {
  final Box<dynamic> _box;

  PasswordLocalDataSourceImpl(@Named('passwordBox') this._box);

  @override
  Future<List<PasswordEntryModel>> getPasswords() async {
    final values = _box.values.toList();
    AppLogger.debug(
      'Raw box "${_box.name}" values: ${values.length}',
      tag: 'HiveDataSource',
    );
    final entries = values.whereType<PasswordEntryModel>().toList();
    AppLogger.debug(
      'Filtered PasswordEntryModel entries: ${entries.length}',
      tag: 'HiveDataSource',
    );
    return entries;
  }

  @override
  Future<PasswordEntryModel?> getPassword(String id) async {
    final value = _box.get(id);
    if (value != null && value is PasswordEntryModel) {
      return value;
    }
    return null;
  }

  @override
  Future<void> savePassword(PasswordEntryModel entry) async {
    AppLogger.debug(
      'Saving entry "${entry.id}" to Hive box "${_box.name}"',
      tag: 'HiveDataSource',
    );
    await _box.put(entry.id, entry);
    AppLogger.debug(
      'Successfully saved entry "${entry.id}"',
      tag: 'HiveDataSource',
    );
  }

  @override
  Future<void> deletePassword(String id) async {
    AppLogger.debug(
      'Deleting entry "$id" from Hive box "${_box.name}"',
      tag: 'HiveDataSource',
    );
    await _box.delete(id);
  }

  @override
  Future<void> savePasswordsBulk(List<PasswordEntryModel> entries) async {
    AppLogger.info(
      'Bulk saving ${entries.length} entries to Hive box "${_box.name}"',
      tag: 'HiveDataSource',
    );

    // Convert list to map for Hive's putAll()
    final map = {for (var entry in entries) entry.id: entry};

    await _box.putAll(map);

    AppLogger.info(
      'Successfully bulk saved ${entries.length} entries',
      tag: 'HiveDataSource',
    );
  }

  @override
  Future<void> deletePasswordsBulk(List<String> ids) async {
    AppLogger.info(
      'Bulk deleting ${ids.length} entries from Hive box "${_box.name}"',
      tag: 'HiveDataSource',
    );

    await _box.deleteAll(ids);

    AppLogger.info(
      'Successfully bulk deleted ${ids.length} entries',
      tag: 'HiveDataSource',
    );
  }

  @override
  Future<void> clearAllPasswords() async {
    final count = _box.length;

    AppLogger.info(
      'Clearing all $count entries from Hive box "${_box.name}"',
      tag: 'HiveDataSource',
    );

    await _box.clear();

    AppLogger.info('Successfully cleared all passwords', tag: 'HiveDataSource');
  }
}
