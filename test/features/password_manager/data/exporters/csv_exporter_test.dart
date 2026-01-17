import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/password_manager/data/exporters/csv_exporter.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

void main() {
  late CsvExporter exporter;

  setUp(() {
    exporter = CsvExporter();
  });

  group('CsvExporter', () {
    test('exports empty list to CSV with headers only', () {
      final result = exporter.export([]);

      expect(
        result,
        'url,username,password,appName,notes,folder,favorite,lastUpdated\n',
      );
    });

    test('exports single password entry correctly', () {
      final entry = PasswordEntry(
        id: '1',
        appName: 'Google',
        username: 'user@example.com',
        password: 'pass123',
        lastUpdated: DateTime(2024, 1, 1),
        url: 'https://google.com',
        notes: 'My account',
        folder: 'Work',
        favorite: true,
      );

      final result = exporter.export([entry]);

      expect(result, contains('https://google.com'));
      expect(result, contains('user@example.com'));
      expect(result, contains('pass123'));
      expect(result, contains('Google'));
      expect(result, contains('My account'));
      expect(result, contains('Work'));
      expect(result, contains('true'));
      expect(result, contains('2024-01-01'));
    });

    test('exports multiple password entries', () {
      final entries = [
        PasswordEntry(
          id: '1',
          appName: 'Google',
          username: 'user1',
          password: 'pass1',
          lastUpdated: DateTime(2024, 1, 1),
        ),
        PasswordEntry(
          id: '2',
          appName: 'Facebook',
          username: 'user2',
          password: 'pass2',
          lastUpdated: DateTime(2024, 1, 2),
        ),
      ];

      final result = exporter.export(entries);
      final lines = result.trim().split('\n');

      expect(lines.length, 3); // Header + 2 entries
      expect(lines[1], contains('Google'));
      expect(lines[2], contains('Facebook'));
    });

    test('handles null optional fields', () {
      final entry = PasswordEntry(
        id: '1',
        appName: 'Test',
        username: 'user',
        password: 'pass',
        lastUpdated: DateTime(2024, 1, 1),
        // All optional fields are null
      );

      final result = exporter.export([entry]);
      final lines = result.trim().split('\n');

      // url,username,password,appName,notes,folder,favorite,lastUpdated
      // ,user,pass,Test,,,false,2024-01-01T00:00:00.000
      expect(lines[1], startsWith(',user,pass,Test,,,false,2024-01-01'));
    });

    test('properly escapes commas in fields', () {
      final entry = PasswordEntry(
        id: '1',
        appName: 'Test, Inc',
        username: 'user',
        password: 'pass,word',
        lastUpdated: DateTime(2024, 1, 1),
        notes: 'Note with, comma',
      );

      final result = exporter.export([entry]);

      expect(result, contains('"Test, Inc"'));
      expect(result, contains('"pass,word"'));
      expect(result, contains('"Note with, comma"'));
    });

    test('properly escapes quotes in fields', () {
      final entry = PasswordEntry(
        id: '1',
        appName: 'Test "App"',
        username: 'user',
        password: 'pass"word',
        lastUpdated: DateTime(2024, 1, 1),
      );

      final result = exporter.export([entry]);

      expect(result, contains('Test ""App""'));
      expect(result, contains('pass""word'));
    });

    test('exports boolean favorite field correctly', () {
      final favorite = PasswordEntry(
        id: '1',
        appName: 'Favorite',
        username: 'user',
        password: 'pass',
        lastUpdated: DateTime(2024, 1, 1),
        favorite: true,
      );

      final notFavorite = PasswordEntry(
        id: '2',
        appName: 'NotFavorite',
        username: 'user',
        password: 'pass',
        lastUpdated: DateTime(2024, 1, 1),
        favorite: false,
      );

      final favoriteResult = exporter.export([favorite]);
      final notFavoriteResult = exporter.export([notFavorite]);

      expect(favoriteResult, contains('true'));
      expect(notFavoriteResult, contains('false'));
    });

    test('exports date in ISO 8601 format', () {
      final entry = PasswordEntry(
        id: '1',
        appName: 'Test',
        username: 'user',
        password: 'pass',
        lastUpdated: DateTime(2024, 3, 15, 14, 30, 45),
      );

      final result = exporter.export([entry]);

      expect(result, contains('2024-03-15'));
    });
  });
}
