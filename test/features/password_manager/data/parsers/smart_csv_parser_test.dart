import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/password_manager/data/parsers/smart_csv_parser.dart';
import 'package:passvault/features/password_manager/domain/entities/import_source_type.dart';

void main() {
  late SmartCsvParser parser;

  setUp(() {
    parser = SmartCsvParser();
  });

  group('$SmartCsvParser', () {
    group('Chrome format', () {
      test('parses Chrome CSV correctly', () async {
        const csvContent = '''name,url,username,password
Google,https://google.com,user@example.com,pass123
Facebook,https://facebook.com,fbuser,fbpass456''';

        final result = await parser.parse(csvContent);

        expect(result, hasLength(2));
        expect(result[0].appName, 'google.com');
        expect(result[0].username, 'user@example.com');
        expect(result[0].password, 'pass123');
        expect(result[0].url, 'https://google.com');
        expect(result[1].appName, 'facebook.com');
      });
    });

    group('Firefox format', () {
      test('parses Firefox CSV correctly', () async {
        const csvContent =
            '''url,username,password,httpRealm,formActionOrigin,guid,timeCreated,timeLastUsed,timePasswordChanged
https://github.com,gituser,gitpass,,,{123},1234567890,1234567890,1234567890
https://twitter.com,twuser,twpass,,,{456},1234567890,1234567890,1234567890''';

        final result = await parser.parse(csvContent);

        expect(result, hasLength(2));
        expect(result[0].appName, 'github.com');
        expect(result[0].username, 'gituser');
        expect(result[0].password, 'gitpass');
        expect(result[1].appName, 'twitter.com');
      });
    });

    group('Bitwarden format', () {
      test('parses Bitwarden CSV correctly', () async {
        const csvContent =
            '''folder,favorite,type,name,notes,fields,reprompt,login_uri,login_username,login_password,login_totp
,1,login,GitHub,My notes,,0,https://github.com,user,pass123,
Work,0,login,Slack,,,0,https://slack.com,slackuser,slackpass,''';

        final result = await parser.parse(csvContent);

        expect(result, hasLength(2));
        expect(result[0].appName, 'github.com');
        expect(result[0].username, 'user');
        expect(result[0].password, 'pass123');
        expect(result[0].notes, 'My notes');
        expect(result[0].favorite, true);
        expect(result[1].folder, 'Work');
        expect(result[1].favorite, false);
      });
    });

    group('1Password format', () {
      test('parses 1Password CSV correctly', () async {
        const csvContent = '''Title,URL,Username,Password,Notes,Type
Amazon,https://amazon.com,amazuser,amazpass,Shopping account,Login
Netflix,https://netflix.com,netuser,netpass,,Login''';

        final result = await parser.parse(csvContent);

        expect(result, hasLength(2));
        expect(result[0].appName, 'amazon.com');
        expect(result[0].username, 'amazuser');
        expect(result[0].password, 'amazpass');
        expect(result[0].notes, 'Shopping account');
        expect(result[1].appName, 'netflix.com');
      });
    });

    group('LastPass format', () {
      test('parses LastPass CSV correctly', () async {
        const csvContent = '''url,username,password,extra,name,grouping,fav
https://reddit.com,reduser,redpass,My note,Reddit,Social,1
https://linkedin.com,linkedin@email.com,linkedpass,,LinkedIn,Work,0''';

        final result = await parser.parse(csvContent);

        expect(result, hasLength(2));
        expect(result[0].appName, 'reddit.com');
        expect(result[0].username, 'reduser');
        expect(result[0].password, 'redpass');
        expect(result[0].notes, 'My note');
        expect(result[0].favorite, true);
        expect(result[0].folder, 'Social');
        expect(result[1].favorite, false);
        expect(result[1].folder, 'Work');
      });
    });

    group('Generic CSV format', () {
      test('parses generic CSV with common columns', () async {
        const csvContent = '''website,user,pass
example.com,testuser,testpass
test.org,user2,pass2''';

        final result = await parser.parse(csvContent);

        expect(result, hasLength(2));
        expect(result[0].appName, 'example.com');
        expect(result[0].username, 'testuser');
        expect(result[0].password, 'testpass');
      });
    });

    group('Force format override', () {
      test('uses forced format when specified', () async {
        const csvContent = '''name,url,username,password
Google,https://google.com,user,pass''';

        final result = await parser.parse(
          csvContent,
          forceFormat: ImportSourceType.chrome,
        );

        expect(result, hasLength(1));
        expect(result[0].appName, 'google.com');
      });
    });

    group('Domain extraction', () {
      test('extracts domain from various URL formats', () async {
        const csvContent = '''name,url,username,password
Test1,https://www.example.com/path,user1,pass1
Test2,http://subdomain.test.org:8080,user2,pass2
Test3,example.net,user3,pass3''';

        final result = await parser.parse(csvContent);

        expect(result[0].appName, 'example.com');
        expect(result[1].appName, 'test.org');
        expect(result[2].appName, 'example.net');
      });
    });

    group('Error handling', () {
      test('throws ParsingException for empty CSV', () async {
        expect(() => parser.parse(''), throwsA(isA<ParsingException>()));
      });

      test('throws ParsingException for CSV with only headers', () async {
        expect(
          () => parser.parse('url,username,password'),
          throwsA(isA<ParsingException>()),
        );
      });

      test('skips rows with missing required fields', () async {
        const csvContent = '''url,username,password
https://example.com,user,pass
https://test.com,,  
https://valid.com,validuser,validpass''';

        final result = await parser.parse(csvContent);

        expect(result, hasLength(2));
        expect(result[0].appName, 'example.com');
        expect(result[1].appName, 'valid.com');
      });
    });

    group('Special characters', () {
      test('handles passwords with commas and quotes', () async {
        const csvContent = '''url,username,password
"https://example.com","user","pass,with,commas"
"https://test.com","user2","pass""with""quotes"''';

        final result = await parser.parse(csvContent);

        expect(result, hasLength(2));
        expect(result[0].password, 'pass,with,commas');
        expect(result[1].password, 'pass"with"quotes');
      });
    });
  });
}
