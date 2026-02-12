import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:pointycastle/export.dart';

/// Provides AES-256-GCM encryption for data export/import.
///
/// This service uses password-based key derivation (Argon2id) to create
/// a strong 256-bit encryption key from a user-provided password.
///
/// This ensures exported data can be securely transported and imported
/// on other devices by providing high resistance to brute-force attacks.
@lazySingleton
class CryptoService {
  /// Salt length in bytes for Argon2id.
  static const int _saltLength = 32;

  /// IV (nonce) length in bytes for AES-GCM.
  static const int _ivLength = 12;

  /// Authentication tag length in bytes for AES-GCM.
  static const int _tagLength = 16;

  /// Key length in bytes (256 bits for AES-256).
  static const int _keyLength = 32;

  /// Argon2 parameters
  static const int _argon2Iterations = 3;
  static const int _argon2Memory = 65536; // 64MB in KB
  static const int _argon2Lanes = 4;

  /// Encrypts data with a password using AES-256-GCM.
  ///
  /// The output format is:
  /// `[salt (32 bytes)][iv (12 bytes)][ciphertext + tag]`
  ///
  /// Returns the encrypted data as [Uint8List].
  Uint8List encryptWithPassword(Uint8List data, String password) {
    // Generate random salt and IV
    final secureRandom = _createSecureRandom();
    final salt = secureRandom.nextBytes(_saltLength);
    final iv = secureRandom.nextBytes(_ivLength);

    // Derive key from password using Argon2id
    final key = _deriveKey(password, salt);

    // Encrypt using AES-GCM
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true, // encrypt
        AEADParameters(
          KeyParameter(key),
          _tagLength * 8, // tag length in bits
          iv,
          Uint8List(0), // no additional authenticated data
        ),
      );

    // Output size includes the tag
    final outputSize = cipher.getOutputSize(data.length);
    final cipherText = Uint8List(outputSize);

    var offset = cipher.processBytes(data, 0, data.length, cipherText, 0);
    offset += cipher.doFinal(cipherText, offset);

    // Use only the actual output
    final actualCipherText = Uint8List.sublistView(cipherText, 0, offset);

    // Combine salt + iv + ciphertext (includes tag)
    final result = Uint8List(_saltLength + _ivLength + actualCipherText.length);
    result.setRange(0, _saltLength, salt);
    result.setRange(_saltLength, _saltLength + _ivLength, iv);
    result.setRange(_saltLength + _ivLength, result.length, actualCipherText);

    return result;
  }

  /// Decrypts data that was encrypted with [encryptWithPassword].
  ///
  /// Throws [ArgumentError] if the data is too short or malformed.
  /// Throws [StateError] if the password is incorrect or data is corrupted.
  Uint8List decryptWithPassword(Uint8List encryptedData, String password) {
    const minLength = _saltLength + _ivLength + _tagLength;
    if (encryptedData.length < minLength) {
      throw ArgumentError('Encrypted data is too short');
    }

    // Extract salt, iv, and ciphertext (which includes the tag)
    final salt = Uint8List.sublistView(encryptedData, 0, _saltLength);
    final iv = Uint8List.sublistView(
      encryptedData,
      _saltLength,
      _saltLength + _ivLength,
    );
    final cipherTextWithTag = Uint8List.sublistView(
      encryptedData,
      _saltLength + _ivLength,
    );

    // Derive key from password using Argon2id
    final key = _deriveKey(password, salt);

    // Decrypt using AES-GCM
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false, // decrypt
        AEADParameters(KeyParameter(key), _tagLength * 8, iv, Uint8List(0)),
      );

    try {
      final outputSize = cipher.getOutputSize(cipherTextWithTag.length);
      final plainText = Uint8List(outputSize);

      var offset = cipher.processBytes(
        cipherTextWithTag,
        0,
        cipherTextWithTag.length,
        plainText,
        0,
      );
      offset += cipher.doFinal(plainText, offset);

      // Return only the actual plaintext
      return Uint8List.sublistView(plainText, 0, offset);
    } catch (e) {
      throw StateError(
        'Decryption failed: incorrect password or corrupted data',
      );
    }
  }

  /// Encrypts a string and returns it as base64-encoded string.
  String encryptStringWithPassword(String data, String password) {
    final bytes = utf8.encode(data);
    final encrypted = encryptWithPassword(Uint8List.fromList(bytes), password);
    return base64Encode(encrypted);
  }

  /// Decrypts a base64-encoded encrypted string.
  String decryptStringWithPassword(String encryptedBase64, String password) {
    final encrypted = base64Decode(encryptedBase64);
    final decrypted = decryptWithPassword(
      Uint8List.fromList(encrypted),
      password,
    );
    return utf8.decode(decrypted);
  }

  /// Derives a 256-bit key from a password using Argon2id.
  Uint8List _deriveKey(String password, Uint8List salt) {
    final argon2 = Argon2BytesGenerator();
    argon2.init(
      Argon2Parameters(
        Argon2Parameters.ARGON2_id,
        salt,
        desiredKeyLength: _keyLength,
        iterations: _argon2Iterations,
        memory: _argon2Memory,
        lanes: _argon2Lanes,
      ),
    );

    final key = argon2.process(Uint8List.fromList(utf8.encode(password)));
    return key;
  }

  /// Hashes a password using Argon2id for secure storage/verification.
  ///
  /// Returns `base64(salt):base64(hash)`.
  String hashPassword(String password) {
    final secureRandom = _createSecureRandom();
    final salt = secureRandom.nextBytes(_saltLength);
    final hash = _deriveKey(password, salt);

    return '${base64Encode(salt)}:${base64Encode(hash)}';
  }

  /// Verifies a password against a stored `base64(salt):base64(hash)` string.
  bool verifyPassword(String password, String storedHash) {
    try {
      final parts = storedHash.split(':');
      if (parts.length != 2) return false;

      final salt = base64Decode(parts[0]);
      final expectedHash = base64Decode(parts[1]);

      final actualHash = _deriveKey(password, salt);

      if (actualHash.length != expectedHash.length) return false;

      // Constant-time comparison to prevent timing attacks
      var result = 0;
      for (var i = 0; i < actualHash.length; i++) {
        result |= actualHash[i] ^ expectedHash[i];
      }
      return result == 0;
    } catch (_) {
      return false;
    }
  }

  /// Creates a secure random number generator.
  SecureRandom _createSecureRandom() {
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seed = Uint8List(32);
    for (int i = 0; i < 32; i++) {
      seed[i] = random.nextInt(256);
    }
    secureRandom.seed(KeyParameter(seed));
    return secureRandom;
  }
}
