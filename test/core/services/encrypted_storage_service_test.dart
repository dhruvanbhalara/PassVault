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

  group('$EncryptedStorageService', () {
    group(r'$getOrCreateEncryptionKey', () {
      test('returns existing key when present', () async {
        const storedKey = 'dGVzdGtleTEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2';
        when(
          () => mockSecureStorage.read(key: keyName),
        ).thenAnswer((_) async => storedKey);

        final result = await service.getOrCreateEncryptionKey();

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
        when(
          () => mockSecureStorage.read(key: keyName),
        ).thenAnswer((_) async => null);
        when(
          () => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        final result = await service.getOrCreateEncryptionKey();

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

    group(r'$hasEncryptionKey', () {
      test('returns true when key exists', () async {
        when(
          () => mockSecureStorage.read(key: keyName),
        ).thenAnswer((_) async => 'someKey');

        final result = await service.hasEncryptionKey();

        expect(result, isTrue);
      });

      test('returns false when key does not exist', () async {
        when(
          () => mockSecureStorage.read(key: keyName),
        ).thenAnswer((_) async => null);

        final result = await service.hasEncryptionKey();

        expect(result, isFalse);
      });
    });

    group(r'$deleteEncryptionKey', () {
      test('deletes key from secure storage', () async {
        when(
          () => mockSecureStorage.delete(key: keyName),
        ).thenAnswer((_) async {});

        await service.deleteEncryptionKey();

        verify(() => mockSecureStorage.delete(key: keyName)).called(1);
      });
    });
  });
}
