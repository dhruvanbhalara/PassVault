import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/constants/storage_keys.dart';
import 'package:passvault/core/services/encrypted_storage_service.dart';
import 'package:passvault/features/password_manager/data/models/password_entry_model.dart';

/// Injectable module for platform-specific and async-initialized dependencies.
///
/// Provides:
/// - [FlutterSecureStorage] - Platform secure storage
/// - [Box] instances - Encrypted Hive boxes for passwords and settings
@module
abstract class StorageModule {
  /// Provides the platform secure storage instance.
  @preResolve
  @singleton
  Future<FlutterSecureStorage> get secureStorage async {
    return const FlutterSecureStorage(aOptions: AndroidOptions());
  }

  /// Opens the encrypted password box.
  /// This must resolve first as it initializes Hive.
  @preResolve
  @singleton
  @Named('passwordBox')
  Future<Box<dynamic>> openPasswordBox(
    EncryptedStorageService encryptedStorageService,
  ) async {
    // Initialize Hive first
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(PasswordEntryModelAdapter().typeId)) {
      Hive.registerAdapter(PasswordEntryModelAdapter());
    }

    final encryptionKey = await encryptedStorageService
        .getOrCreateEncryptionKey();

    return Hive.openBox(
      StorageKeys.passwordBox,
      encryptionCipher: HiveAesCipher(Uint8List.fromList(encryptionKey)),
    );
  }

  /// Opens the encrypted settings box.
  /// Depends on passwordBox to ensure Hive is initialized first.
  @preResolve
  @singleton
  @Named('settingsBox')
  Future<Box<dynamic>> openSettingsBox(
    EncryptedStorageService encryptedStorageService,
    @Named('passwordBox') Box<dynamic> passwordBox,
  ) async {
    final encryptionKey = await encryptedStorageService
        .getOrCreateEncryptionKey();

    return Hive.openBox(
      StorageKeys.settingsBox,
      encryptionCipher: HiveAesCipher(Uint8List.fromList(encryptionKey)),
    );
  }
}
