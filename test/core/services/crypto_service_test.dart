import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/services/crypto_service.dart';

void main() {
  late CryptoService cryptoService;

  setUp(() {
    cryptoService = CryptoService();
  });

  group('$CryptoService', () {
    const testPassword = 'TestPassword123!';
    const testData = 'This is sensitive data to be encrypted';

    group('encryptWithPassword and decryptWithPassword', () {
      test('encrypts and decrypts data correctly', () {
        // Arrange
        final originalData = Uint8List.fromList(utf8.encode(testData));

        // Act
        final encrypted = cryptoService.encryptWithPassword(
          originalData,
          testPassword,
        );
        final decrypted = cryptoService.decryptWithPassword(
          encrypted,
          testPassword,
        );

        // Assert
        expect(decrypted, equals(originalData));
        expect(utf8.decode(decrypted), equals(testData));
      });

      test('produces different ciphertext for same plaintext (random IV)', () {
        // Arrange
        final originalData = Uint8List.fromList(utf8.encode(testData));

        // Act
        final encrypted1 = cryptoService.encryptWithPassword(
          originalData,
          testPassword,
        );
        final encrypted2 = cryptoService.encryptWithPassword(
          originalData,
          testPassword,
        );

        // Assert - ciphertext should be different due to random IV/salt
        expect(encrypted1, isNot(equals(encrypted2)));
      });

      test('fails decryption with wrong password', () {
        // Arrange
        final originalData = Uint8List.fromList(utf8.encode(testData));
        final encrypted = cryptoService.encryptWithPassword(
          originalData,
          testPassword,
        );

        // Act & Assert
        expect(
          () => cryptoService.decryptWithPassword(encrypted, 'WrongPassword'),
          throwsA(isA<StateError>()),
        );
      });

      test('throws ArgumentError for data that is too short', () {
        // Arrange
        final tooShort = Uint8List(10);

        // Act & Assert
        expect(
          () => cryptoService.decryptWithPassword(tooShort, testPassword),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('encrypted data contains salt, IV, ciphertext, and tag', () {
        // Arrange
        final originalData = Uint8List.fromList(utf8.encode(testData));

        // Act
        final encrypted = cryptoService.encryptWithPassword(
          originalData,
          testPassword,
        );

        // Assert
        // Minimum length: salt (32) + iv (12) + tag (16) + at least 1 byte of ciphertext
        expect(encrypted.length, greaterThanOrEqualTo(61));
      });
    });

    group('encryptStringWithPassword and decryptStringWithPassword', () {
      test('encrypts and decrypts string correctly', () {
        // Act
        final encrypted = cryptoService.encryptStringWithPassword(
          testData,
          testPassword,
        );
        final decrypted = cryptoService.decryptStringWithPassword(
          encrypted,
          testPassword,
        );

        // Assert
        expect(decrypted, equals(testData));
      });

      test('returns base64-encoded string', () {
        // Act
        final encrypted = cryptoService.encryptStringWithPassword(
          testData,
          testPassword,
        );

        // Assert - should be valid base64
        expect(() => base64Decode(encrypted), returnsNormally);
      });

      test('handles unicode strings', () {
        // Arrange
        const unicodeData = 'Hello 世界 🔐 Привет';

        // Act
        final encrypted = cryptoService.encryptStringWithPassword(
          unicodeData,
          testPassword,
        );
        final decrypted = cryptoService.decryptStringWithPassword(
          encrypted,
          testPassword,
        );

        // Assert
        expect(decrypted, equals(unicodeData));
      });

      test('handles empty string', () {
        // Arrange
        const emptyData = '';

        // Act
        final encrypted = cryptoService.encryptStringWithPassword(
          emptyData,
          testPassword,
        );
        final decrypted = cryptoService.decryptStringWithPassword(
          encrypted,
          testPassword,
        );

        // Assert
        expect(decrypted, equals(emptyData));
      });

      test('handles large data', () {
        // Arrange
        final largeData = 'A' * 100000; // 100KB of data

        // Act
        final encrypted = cryptoService.encryptStringWithPassword(
          largeData,
          testPassword,
        );
        final decrypted = cryptoService.decryptStringWithPassword(
          encrypted,
          testPassword,
        );

        // Assert
        expect(decrypted, equals(largeData));
      });
    });

    group('password security', () {
      test('different passwords produce different ciphertext', () {
        // Arrange
        final originalData = Uint8List.fromList(utf8.encode(testData));

        // Act
        final encrypted1 = cryptoService.encryptWithPassword(
          originalData,
          'Password1',
        );
        final encrypted2 = cryptoService.encryptWithPassword(
          originalData,
          'Password2',
        );

        // Assert
        expect(encrypted1, isNot(equals(encrypted2)));
      });

      test('similar passwords produce different results', () {
        // Arrange
        final originalData = Uint8List.fromList(utf8.encode(testData));

        // Act
        final encrypted1 = cryptoService.encryptWithPassword(
          originalData,
          'Password',
        );
        final encrypted2 = cryptoService.encryptWithPassword(
          originalData,
          'Passwords',
        );

        // Assert
        expect(encrypted1, isNot(equals(encrypted2)));
      });
    });
  });
}
