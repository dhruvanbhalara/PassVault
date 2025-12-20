import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/data/models/password_entry_model.dart';

@module
abstract class StorageModule {
  @preResolve
  @singleton
  Future<FlutterSecureStorage> get secureStorage async {
    return const FlutterSecureStorage();
  }

  @preResolve
  @singleton
  Future<Box<dynamic>> openBox() async {
    await Hive.initFlutter();

    // Register Adapter
    Hive.registerAdapter(PasswordEntryModelAdapter());

    const secureStorage = FlutterSecureStorage();
    final encryptionKeyString = await secureStorage.read(key: 'hive_key');

    List<int> encryptionKey;
    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(key: 'hive_key', value: base64UrlEncode(key));
      encryptionKey = key;
    } else {
      encryptionKey = base64Url.decode(encryptionKeyString);
    }

    // Open the box with encryption
    return await Hive.openBox(
      'passvault_box',
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }
}
