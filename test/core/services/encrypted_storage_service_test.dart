import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/services/encrypted_storage_service.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late EncryptedStorageService service;
  late MockFlutterSecureStorage mockSecureStorage;

  const keyName = 'passvault_encryption_key';

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    service = EncryptedStorageService(mockSecureStorage);
  });

  group('EncryptedStorageService', () {
    group('getOrCreateEncryptionKey', () {
      test('returns existing key when present', () async {
        // Arrange
        const storedKey = 'dGVzdGtleTEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2';
        when(
          () => mockSecureStorage.read(key: keyName),
        ).thenAnswer((_) async => storedKey);

        // Act
        final result = await service.getOrCreateEncryptionKey();

        // Assert
        expect(result, isA<Uint8List>());
        expect(result.length, greaterThan(0));
        verify(() => mockSecureStorage.read(key: keyName)).called(1);
        verifyNever(
          () => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        );
      });

      test('generates and stores new key when not present', () async {
        // Arrange
        when(
          () => mockSecureStorage.read(key: keyName),
        ).thenAnswer((_) async => null);
        when(
          () => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        // Act
        final result = await service.getOrCreateEncryptionKey();

        // Assert
        expect(result, isA<Uint8List>());
        expect(result.length, equals(32)); // 256 bits = 32 bytes
        verify(() => mockSecureStorage.read(key: keyName)).called(1);
        verify(
          () => mockSecureStorage.write(
            key: keyName,
            value: any(named: 'value'),
          ),
        ).called(1);
      });
    });

    group('hasEncryptionKey', () {
      test('returns true when key exists', () async {
        // Arrange
        when(
          () => mockSecureStorage.read(key: keyName),
        ).thenAnswer((_) async => 'someKey');

        // Act
        final result = await service.hasEncryptionKey();

        // Assert
        expect(result, isTrue);
      });

      test('returns false when key does not exist', () async {
        // Arrange
        when(
          () => mockSecureStorage.read(key: keyName),
        ).thenAnswer((_) async => null);

        // Act
        final result = await service.hasEncryptionKey();

        // Assert
        expect(result, isFalse);
      });
    });

    group('deleteEncryptionKey', () {
      test('deletes key from secure storage', () async {
        // Arrange
        when(
          () => mockSecureStorage.delete(key: keyName),
        ).thenAnswer((_) async {});

        // Act
        await service.deleteEncryptionKey();

        // Assert
        verify(() => mockSecureStorage.delete(key: keyName)).called(1);
      });
    });
  });
}
