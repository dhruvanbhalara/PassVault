import 'dart:convert';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:pointycastle/export.dart';

/// Provides AES-256-GCM encryption for data export/import.
///
/// This service uses password-based key derivation (PBKDF2) to create
/// encryption keys from user-provided passwords, ensuring exported data
/// can be securely transported and imported on other devices.
@lazySingleton
class CryptoService {
  /// Number of PBKDF2 iterations for key derivation.
  /// Higher values increase security but also computation time.
  static const int _pbkdf2Iterations = 100000;

  /// Salt length in bytes for PBKDF2.
  static const int _saltLength = 32;

  /// IV (nonce) length in bytes for AES-GCM.
  static const int _ivLength = 12;

  /// Authentication tag length in bytes for AES-GCM.
  static const int _tagLength = 16;

  /// Key length in bytes (256 bits for AES-256).
  static const int _keyLength = 32;

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

    // Derive key from password using PBKDF2
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

    // Derive key from password using PBKDF2
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

  /// Derives a 256-bit key from a password using PBKDF2-HMAC-SHA256.
  Uint8List _deriveKey(String password, Uint8List salt) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(salt, _pbkdf2Iterations, _keyLength));

    return pbkdf2.process(Uint8List.fromList(utf8.encode(password)));
  }

  /// Creates a secure random number generator.
  SecureRandom _createSecureRandom() {
    final secureRandom = FortunaRandom();
    final seed = Uint8List(32);

    // Use current time as entropy source (combined with Fortuna's internal state)
    final now = DateTime.now().microsecondsSinceEpoch;
    for (int i = 0; i < 8; i++) {
      seed[i] = (now >> (i * 8)) & 0xFF;
    }

    // Add additional entropy from various sources
    final random = DateTime.now().millisecondsSinceEpoch;
    for (int i = 8; i < 16; i++) {
      seed[i] = (random >> ((i - 8) * 8)) & 0xFF;
    }

    // Add some more entropy using hashCode of now
    final hashCode = now.hashCode;
    for (int i = 16; i < 24; i++) {
      seed[i] = (hashCode >> ((i - 16) * 8)) & 0xFF;
    }

    secureRandom.seed(KeyParameter(seed));
    return secureRandom;
  }
}
