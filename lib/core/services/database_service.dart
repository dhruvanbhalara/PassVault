import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DatabaseService {
  static const String _settingsBoxName = 'settings';

  Future<void> init() async {
    // initFlutter is provided by the hive_ce_flutter package
    await Hive.initFlutter();
    await Hive.openBox(_settingsBoxName);
  }

  Box getBox(String name) {
    return Hive.box(name);
  }

  Box get settingsBox => Hive.box(_settingsBoxName);

  Future<void> write(String boxName, String key, dynamic value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  dynamic read(String boxName, String key, {dynamic defaultValue}) {
    final box = Hive.box(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  Future<void> delete(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  Future<void> clear(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }
}
