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
        final originalData = Uint8List.fromList(utf8.encode(testData));

        final encrypted = cryptoService.encryptWithPassword(
          originalData,
          testPassword,
        );
        final decrypted = cryptoService.decryptWithPassword(
          encrypted,
          testPassword,
        );

        expect(decrypted, equals(originalData));
        expect(utf8.decode(decrypted), equals(testData));
      });

      test('produces different ciphertext for same plaintext (random IV)', () {
        final originalData = Uint8List.fromList(utf8.encode(testData));

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
        final tooShort = Uint8List(10);

        // Act & Assert
        expect(
          () => cryptoService.decryptWithPassword(tooShort, testPassword),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('encrypted data contains salt, IV, ciphertext, and tag', () {
        final originalData = Uint8List.fromList(utf8.encode(testData));

        final encrypted = cryptoService.encryptWithPassword(
          originalData,
          testPassword,
        );

        // Minimum length: salt (32) + iv (12) + tag (16) + at least 1 byte of ciphertext
        expect(encrypted.length, greaterThanOrEqualTo(61));
      });
    });

    group('encryptStringWithPassword and decryptStringWithPassword', () {
      test('encrypts and decrypts string correctly', () {
        final encrypted = cryptoService.encryptStringWithPassword(
          testData,
          testPassword,
        );
        final decrypted = cryptoService.decryptStringWithPassword(
          encrypted,
          testPassword,
        );

        expect(decrypted, equals(testData));
      });

      test('returns base64-encoded string', () {
        final encrypted = cryptoService.encryptStringWithPassword(
          testData,
          testPassword,
        );

        // Assert - should be valid base64
        expect(() => base64Decode(encrypted), returnsNormally);
      });

      test('handles unicode strings', () {
        const unicodeData = 'Hello 世界 🔐 Привет';

        final encrypted = cryptoService.encryptStringWithPassword(
          unicodeData,
          testPassword,
        );
        final decrypted = cryptoService.decryptStringWithPassword(
          encrypted,
          testPassword,
        );

        expect(decrypted, equals(unicodeData));
      });

      test('handles empty string', () {
        const emptyData = '';

        final encrypted = cryptoService.encryptStringWithPassword(
          emptyData,
          testPassword,
        );
        final decrypted = cryptoService.decryptStringWithPassword(
          encrypted,
          testPassword,
        );

        expect(decrypted, equals(emptyData));
      });

      test('handles large data', () {
        final largeData = 'A' * 100000; // 100KB of data

        final encrypted = cryptoService.encryptStringWithPassword(
          largeData,
          testPassword,
        );
        final decrypted = cryptoService.decryptStringWithPassword(
          encrypted,
          testPassword,
        );

        expect(decrypted, equals(largeData));
      });
    });

    group('password security', () {
      test('different passwords produce different ciphertext', () {
        final originalData = Uint8List.fromList(utf8.encode(testData));

        final encrypted1 = cryptoService.encryptWithPassword(
          originalData,
          'Password1',
        );
        final encrypted2 = cryptoService.encryptWithPassword(
          originalData,
          'Password2',
        );

        expect(encrypted1, isNot(equals(encrypted2)));
      });

      test('similar passwords produce different results', () {
        final originalData = Uint8List.fromList(utf8.encode(testData));

        final encrypted1 = cryptoService.encryptWithPassword(
          originalData,
          'Password',
        );
        final encrypted2 = cryptoService.encryptWithPassword(
          originalData,
          'Passwords',
        );

        expect(encrypted1, isNot(equals(encrypted2)));
      });
    });
  });
}
