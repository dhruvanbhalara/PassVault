import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

void main() {
  group('PasswordEntry', () {
    final tLastUpdated = DateTime(2023, 1, 1);

    final tPasswordEntry = PasswordEntry(
      id: '1',
      appName: 'TestApp',
      username: 'testuser',
      password: 'password123',
      lastUpdated: tLastUpdated,
      url: 'https://test.com',
      notes: 'test notes',
      folder: 'testFolder',
      favorite: true,
    );

    test('should copyWith correctly', () {
      final updated = tPasswordEntry.copyWith(
        appName: 'NewApp',
        favorite: false,
      );

      expect(updated.id, '1');
      expect(updated.appName, 'NewApp');
      expect(updated.username, 'testuser');
      expect(updated.favorite, false);
      expect(updated.url, 'https://test.com');
    });

    test('should support equality via Equatable', () {
      final entry2 = PasswordEntry(
        id: '1',
        appName: 'TestApp',
        username: 'testuser',
        password: 'password123',
        lastUpdated: tLastUpdated,
        url: 'https://test.com',
        notes: 'test notes',
        folder: 'testFolder',
        favorite: true,
      );

      expect(tPasswordEntry, equals(entry2));
    });

    test('toJson should return a valid Map', () {
      final result = tPasswordEntry.toJson();

      final expectedMap = {
        'id': '1',
        'appName': 'TestApp',
        'username': 'testuser',
        'password': 'password123',
        'lastUpdated': tLastUpdated.toIso8601String(),
        'url': 'https://test.com',
        'notes': 'test notes',
        'folder': 'testFolder',
        'favorite': true,
      };

      expect(result, expectedMap);
    });

    test('fromJson should return a valid PasswordEntry from Map', () {
      final jsonMap = {
        'id': '1',
        'appName': 'TestApp',
        'username': 'testuser',
        'password': 'password123',
        'lastUpdated': tLastUpdated.toIso8601String(),
        'url': 'https://test.com',
        'notes': 'test notes',
        'folder': 'testFolder',
        'favorite': true,
      };

      final result = PasswordEntry.fromJson(jsonMap);

      expect(result, tPasswordEntry);
    });

    test('fromJson should handle optional fields properly', () {
      final jsonMap = {
        'id': '2',
        'appName': 'OptApp',
        'username': 'optuser',
        'password': 'optpassword',
        'lastUpdated': tLastUpdated.toIso8601String(),
      };

      final result = PasswordEntry.fromJson(jsonMap);

      expect(result.id, '2');
      expect(result.appName, 'OptApp');
      expect(result.favorite, false);
      expect(result.url, isNull);
    });
  });
}
