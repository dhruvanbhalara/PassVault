import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/core/services/helpers/csv_import_helper.dart';

void main() {
  group('CsvImportHelper Provider Diversity Tests', () {
    test('should parse Google-style CSV (name, url, username, password)', () {
      const csv =
          'name,url,username,password\n'
          'Google,https://google.com,user@gmail.com,pass123';

      final results = CsvImportHelper.parse(csv);

      expect(results.length, 1);
      expect(results[0].appName, 'Google');
      expect(results[0].url, 'https://google.com');
      expect(results[0].username, 'user@gmail.com');
      expect(results[0].password, 'pass123');
    });

    test(
      'should parse Generic-style CSV (App Name, User, Pass, Link, Note)',
      () {
        const csv =
            'App Name,User,Pass,Link,Note\n'
            'Facebook,fb_user,fb_pass,https://fb.com,My social account';

        final results = CsvImportHelper.parse(csv);

        expect(results.length, 1);
        expect(results[0].appName, 'Facebook');
        expect(results[0].username, 'fb_user');
        expect(results[0].password, 'fb_pass');
        expect(results[0].url, 'https://fb.com');
        expect(results[0].notes, 'My social account');
      },
    );

    test(
      'should parse Bitwarden-style CSV (folder,favorite,type,name,notes,fields,repropritiated,login_uri,login_username,login_password,login_totp)',
      () {
        // Simplified Bitwarden-like headers
        const csv =
            'folder,favorite,type,name,notes,login_uri,login_username,login_password\n'
            'Personal,1,login,Github,Dev account,https://github.com,git_user,git_pass';

        final results = CsvImportHelper.parse(csv);

        expect(results.length, 1);
        expect(results[0].appName, 'Github');
        expect(results[0].username, 'git_user');
        expect(results[0].password, 'git_pass');
        expect(results[0].url, 'https://github.com');
        expect(results[0].notes, 'Dev account');
        expect(results[0].folder, 'Personal');
        expect(results[0].favorite, isTrue);
      },
    );

    test('should handle varying column counts and missing optional fields', () {
      const csv =
          'name,username,password\n'
          'Slack,slack_user,slack_pass\n'
          'Discord,discord_user,discord_pass';

      final results = CsvImportHelper.parse(csv);

      expect(results.length, 2);
      expect(results[0].appName, 'Slack');
      expect(results[1].appName, 'Discord');
      expect(results[0].url, isNull);
      expect(results[0].notes, isNull);
    });

    test(
      'should generate unique IDs for each imported entry even with same app/user',
      () {
        const csv =
            'name,username,password\n'
            'Test,test,test\n'
            'Test,test,test';

        final results = CsvImportHelper.parse(csv);

        expect(results.length, 2);
        expect(results[0].id, isNot(equals(results[1].id)));
        expect(results[0].appName, results[1].appName);
        expect(results[0].username, results[1].username);
      },
    );

    test('should handle empty rows or invalid content gracefully', () {
      const csv =
          'name,username,password\n'
          '\n'
          'Valid,user,pass\n'
          ' , , \n';

      final results = CsvImportHelper.parse(csv);

      // CsvToListConverter might treat empty lines in different ways depending on config
      // but CsvImportHelper.parse filters dataRows by length < 2
      expect(results.length, 1);
      expect(results[0].appName, 'Valid');
    });
  });
}
