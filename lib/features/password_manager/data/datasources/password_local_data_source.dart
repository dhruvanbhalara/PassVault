import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/data/models/password_entry_model.dart';

/// Abstract interface for local password data operations.
abstract class PasswordLocalDataSource {
  /// Retrieves all stored password entries.
  Future<List<PasswordEntryModel>> getPasswords();

  /// Saves a password entry to local storage.
  Future<void> savePassword(PasswordEntryModel entry);

  /// Deletes a password entry by its ID.
  Future<void> deletePassword(String id);
}

/// Implementation of [PasswordLocalDataSource] using Hive.
@LazySingleton(as: PasswordLocalDataSource)
class PasswordLocalDataSourceImpl implements PasswordLocalDataSource {
  final Box<dynamic> _box;

  PasswordLocalDataSourceImpl(@Named('passwordBox') this._box);

  @override
  Future<List<PasswordEntryModel>> getPasswords() async {
    return _box.values.whereType<PasswordEntryModel>().toList();
  }

  @override
  Future<void> savePassword(PasswordEntryModel entry) async {
    await _box.put(entry.id, entry);
  }

  @override
  Future<void> deletePassword(String id) async {
    await _box.delete(id);
  }
}
