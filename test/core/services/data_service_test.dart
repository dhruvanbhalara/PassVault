import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/services/crypto_service.dart';
import 'package:passvault/core/services/data_service.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

class MockCryptoService extends Mock implements CryptoService {}

void main() {
  late DataService dataService;
  late MockCryptoService mockCryptoService;

  setUp(() {
    mockCryptoService = MockCryptoService();
    dataService = DataService(mockCryptoService);
  });

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  group('$DataService', () {
    group('CSV Import Edge Cases', () {
      test('should parse CSV with \n (Linux/macOS) line endings', () {
        const csv =
            'name,username,password\nApp1,user1,pass1\nApp2,user2,pass2';
        final result = dataService.importFromCsv(csv);
        expect(result.length, 2);
        expect(result[0].appName, 'App1');
        expect(result[1].appName, 'App2');
      });

      test('should parse CSV with \r\n (Windows) line endings', () {
        const csv =
            'name,username,password\r\nApp1,user1,pass1\r\nApp2,user2,pass2';
        final result = dataService.importFromCsv(csv);
        expect(result.length, 2);
        expect(result[0].appName, 'App1');
        expect(result[1].appName, 'App2');
      });

      test('should parse CSV with alternate header names (Bitwarden style)', () {
        const csv =
            'name,login_uri,login_username,login_password\nBitwardenApp,https://vault.bitwarden.com,myuser,mypass';
        final result = dataService.importFromCsv(csv);
        expect(result.length, 1);
        expect(result[0].appName, 'BitwardenApp');
        expect(result[0].username, 'myuser');
        expect(result[0].password, 'mypass');
      });

      test('should parse CSV with Google Passwords style header', () {
        const csv =
            'name,url,username,password\nGoogleApp,https://google.com,googleuser,googlepass';
        final result = dataService.importFromCsv(csv);
        expect(result.length, 1);
        expect(result[0].appName, 'GoogleApp');
        expect(result[0].username, 'googleuser');
        expect(result[0].password, 'googlepass');
      });

      test('should handle empty CSV content gracefully', () {
        const csv = '';
        final result = dataService.importFromCsv(csv);
        expect(result, isEmpty);
      });

      test('should handle CSV with only headers gracefully', () {
        const csv = 'name,username,password';
        final result = dataService.importFromCsv(csv);
        expect(result, isEmpty);
      });

      test('should handle rows with missing optional columns', () {
        const csv = 'name,username,password\nAppMinimal,user1,pass1';
        final result = dataService.importFromCsv(csv);
        expect(result.length, 1);
        expect(result[0].appName, 'AppMinimal');
      });

      test('should parse folders/groups from header synonyms', () {
        const csv =
            'name,username,password,folder\nMy App,me,secret,Personal'
            '\nWork App,boss,safe,Work';
        final result = dataService.importFromCsv(csv);

        expect(result.length, 2);

        expect(result[0].appName, 'My App');
        expect(result[0].folder, 'Personal');

        expect(result[1].appName, 'Work App');
        expect(result[1].folder, 'Work');
      });

      test('should parse URL and Notes correctly', () {
        const csv =
            'name,username,password,url,notes\n'
            'FullApp,user,pass,https://app.com,My secrets';
        final result = dataService.importFromCsv(csv);

        expect(result.length, 1);
        expect(result[0].appName, 'FullApp');
        expect(result[0].url, 'https://app.com');
        expect(result[0].notes, 'My secrets');
      });
    });

    group('CSV Generation', () {
      final tEntry = PasswordEntry(
        id: '1',
        appName: 'Test CSV',
        username: 'csvuser',
        password: 'csvpassword',
        url: 'https://example.com',
        notes: 'Some notes',
        folder: 'Work',
        lastUpdated: DateTime(2024, 1, 1),
      );

      test('should generate CSV string from entries', () {
        final entries = [tEntry];
        final csv = dataService.generateCsv(entries);
        expect(csv, contains('Test CSV'));
        expect(csv, contains('csvuser'));
        expect(csv, contains('csvpassword'));
        expect(csv, contains('https://example.com'));
        expect(csv, contains('Some notes'));
        expect(csv, contains('Work'));
      });
    });

    group('JSON Export/Import', () {
      final tEntry = PasswordEntry(
        id: '1',
        appName: 'Test',
        username: 'user',
        password: 'pass',
        lastUpdated: DateTime(2024, 1, 1),
      );

      test('should generate valid JSON and import it back', () {
        final entries = [tEntry];
        final json = dataService.generateJson(entries);
        final result = dataService.importFromJson(json);

        expect(result.length, 1);
        expect(result[0].appName, tEntry.appName);
        expect(result[0].username, tEntry.username);
        expect(result[0].password, tEntry.password);
      });
    });

    group('Encrypted Export/Import', () {
      final tEntry = PasswordEntry(
        id: '1',
        appName: 'Secure App',
        username: 'secureuser',
        password: 'securepassword',
        lastUpdated: DateTime(2024, 1, 1),
      );
      final tPassword = 'master-password';

      test('should encrypt and decrypt data correctly', () {
        final entries = [tEntry];
        final encrypted = Uint8List.fromList([1, 2, 3]);

        when(
          () => mockCryptoService.encryptWithPassword(any(), tPassword),
        ).thenReturn(encrypted);
        when(
          () => mockCryptoService.decryptWithPassword(encrypted, tPassword),
        ).thenReturn(
          Uint8List.fromList(utf8.encode(dataService.generateJson(entries))),
        );

        final resultEncrypted = dataService.generateEncryptedJson(
          entries,
          tPassword,
        );
        expect(resultEncrypted, encrypted);

        final resultDecrypted = dataService.importFromEncrypted(
          encrypted,
          tPassword,
        );
        expect(resultDecrypted.length, 1);
        expect(resultDecrypted[0].appName, 'Secure App');
      });
    });
  });
}
