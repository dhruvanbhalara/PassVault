import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/home/domain/services/credential_grouping_service.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

void main() {
  const className = 'CredentialGroupingService';

  PasswordEntry makeEntry({
    required String id,
    required String appName,
    required String username,
    String? url,
    String? folder,
    bool favorite = false,
    DateTime? lastUpdated,
  }) {
    return PasswordEntry(
      id: id,
      appName: appName,
      username: username,
      password: 'pw',
      lastUpdated: lastUpdated ?? DateTime(2026, 1, 1),
      url: url,
      folder: folder,
      favorite: favorite,
    );
  }

  group(className, () {
    const service = CredentialGroupingService();

    test('normalizes target in locked order', () {
      final normalized = service.canonicalizeTarget(
        '  HTTPS://WWW.Example.Com ',
      );

      expect(normalized, 'example.com');
    });

    test(
      'uses fallback chain url appName id and preserves all credentials',
      () {
        final entries = [
          makeEntry(
            id: '1',
            appName: 'Example',
            username: 'first@example.com',
            url: 'https://www.example.com',
          ),
          makeEntry(
            id: '2',
            appName: 'Example',
            username: 'second@example.com',
            url: '  HTTP://example.com ',
          ),
          makeEntry(id: '3', appName: 'Standalone App', username: 'app-user'),
          makeEntry(
            id: 'id-only',
            appName: '  ',
            username: 'id-user',
            url: '   ',
          ),
        ];

        final grouped = service.group(entries);
        final totalMembers = grouped.fold<int>(
          0,
          (sum, group) => sum + group.members.length,
        );

        expect(totalMembers, entries.length);
        expect(
          grouped.map((group) => group.canonicalKey),
          contains('example.com'),
        );
        expect(
          grouped.map((group) => group.canonicalKey),
          contains('standalone app'),
        );
        expect(grouped.map((group) => group.canonicalKey), contains('id-only'));
      },
    );

    test(
      'groups and members are deterministically ordered with id tie-breaker',
      () {
        final entries = [
          makeEntry(
            id: 'b',
            appName: 'Gamma',
            username: 'same-user',
            url: 'https://gamma.com',
            lastUpdated: DateTime(2026, 1, 1),
          ),
          makeEntry(
            id: 'a',
            appName: 'Gamma',
            username: 'same-user',
            url: 'https://www.gamma.com',
            lastUpdated: DateTime(2026, 1, 1),
          ),
          makeEntry(
            id: '3',
            appName: 'Beta',
            username: 'z-user',
            url: 'https://beta.com',
          ),
          makeEntry(
            id: '4',
            appName: 'Alpha',
            username: 'a-user',
            url: 'https://alpha.com',
          ),
        ];

        final grouped = service.group(entries);
        final orderedGroupKeys = grouped
            .map((group) => group.canonicalKey)
            .toList();
        final gammaGroup = grouped.firstWhere(
          (group) => group.canonicalKey == 'gamma.com',
        );
        final gammaMemberIds = gammaGroup.members
            .map((member) => member.id)
            .toList();

        expect(orderedGroupKeys, ['alpha.com', 'beta.com', 'gamma.com']);
        expect(gammaMemberIds, ['a', 'b']);
      },
    );
  });
}
