import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/utils/app_logger.dart';

/// Manages encryption keys for all secure storage operations.
///
/// Centralizes encryption key management for:
/// - Hive box encryption (passwords, settings)
/// - Export/import file encryption
///
/// The encryption key is stored securely using `FlutterSecureStorage`
/// (Keychain on iOS, EncryptedSharedPreferences on Android).
@lazySingleton
class EncryptedStorageService {
  final FlutterSecureStorage _secureStorage;

  static const String _keyName = 'passvault_encryption_key';

  EncryptedStorageService(this._secureStorage);

  /// Retrieves the encryption key from secure storage, or generates a new one
  /// if it doesn't exist.
  ///
  /// Returns a [Uint8List] containing the 32-byte AES-256 encryption key.
  Future<Uint8List> getOrCreateEncryptionKey() async {
    AppLogger.debug(
      'Retrieving encryption key from secure storage',
      tag: 'EncryptedStorage',
    );
    final existingKey = await _secureStorage.read(key: _keyName);

    if (existingKey != null) {
      AppLogger.info(
        'Encryption key found in secure storage',
        tag: 'EncryptedStorage',
      );
      return Uint8List.fromList(base64Url.decode(existingKey));
    }

    AppLogger.warning(
      'No encryption key found. Generating a new one...',
      tag: 'EncryptedStorage',
    );
    final newKey = Hive.generateSecureKey();
    await _secureStorage.write(key: _keyName, value: base64UrlEncode(newKey));
    AppLogger.info(
      'New encryption key generated and saved',
      tag: 'EncryptedStorage',
    );

    return Uint8List.fromList(newKey);
  }

  /// Checks if an encryption key already exists in secure storage.
  Future<bool> hasEncryptionKey() async {
    final key = await _secureStorage.read(key: _keyName);
    return key != null;
  }

  /// Deletes the encryption key from secure storage.
  ///
  /// **WARNING**: This will make all encrypted data unrecoverable.
  Future<void> deleteEncryptionKey() async {
    await _secureStorage.delete(key: _keyName);
  }
}
