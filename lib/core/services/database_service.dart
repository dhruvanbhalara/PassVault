import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

/// Service for reading and writing to Hive storage boxes.
///
/// This service provides a simple interface for CRUD operations on
/// Hive boxes. The actual boxes are injected from [StorageModule]
/// and are encrypted for security.
@lazySingleton
class DatabaseService {
  final Box<dynamic> _settingsBox;

  DatabaseService(@Named('settingsBox') this._settingsBox);

  /// Returns the settings box for direct access if needed.
  Box<dynamic> get settingsBox => _settingsBox;

  /// Writes a value to the settings box.
  Future<void> write(String boxName, String key, dynamic value) async {
    // For now, all settings go to the settings box
    // In the future, we could support multiple boxes
    await _settingsBox.put(key, value);
  }

  /// Reads a value from the settings box.
  dynamic read(String boxName, String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }

  /// Deletes a value from the settings box.
  Future<void> delete(String boxName, String key) async {
    await _settingsBox.delete(key);
  }

  /// Clears all values from the settings box.
  Future<void> clear(String boxName) async {
    await _settingsBox.clear();
  }
}
