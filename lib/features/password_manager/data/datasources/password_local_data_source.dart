import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/data/models/password_entry_model.dart';

abstract class PasswordLocalDataSource {
  Future<List<PasswordEntryModel>> getPasswords();
  Future<void> savePassword(PasswordEntryModel entry);
  Future<void> deletePassword(String id);
}

@LazySingleton(as: PasswordLocalDataSource)
class PasswordLocalDataSourceImpl implements PasswordLocalDataSource {
  final Box<dynamic> _box;

  PasswordLocalDataSourceImpl(this._box);

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
