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
            url: '  HTTP://example.com/path/login ',
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
      'extracts host for path-heavy web urls and prefers appName as display name',
      () {
        final entries = [
          makeEntry(
            id: 'mc-1',
            appName: 'Moneycontrol',
            username: 'u1',
            url: 'https://accounts.moneycontrol.com/mc/login/',
          ),
          makeEntry(
            id: 'mc-2',
            appName: 'Moneycontrol',
            username: 'u2',
            url: 'accounts.moneycontrol.com/auth/signin',
          ),
        ];

        final grouped = service.group(entries);
        final moneycontrolGroup = grouped.firstWhere(
          (group) => group.canonicalKey == 'moneycontrol.com',
        );

        expect(moneycontrolGroup.displayName, 'Moneycontrol');
        expect(moneycontrolGroup.accountCount, 2);
      },
    );

    test('collapses all subdomains to their base registrable domain', () {
      final entries = [
        makeEntry(
          id: 'x-1',
          appName: 'XYZ',
          username: 'u1',
          url: 'https://wwe.xyz.com/signin',
        ),
        makeEntry(
          id: 'x-2',
          appName: 'XYZ',
          username: 'u2',
          url: 'https://xyz.com',
        ),
        makeEntry(
          id: 'x-3',
          appName: 'XYZ',
          username: 'u3',
          url: 'https://accounts.xyz.com/oauth/authorize',
        ),
      ];

      final grouped = service.group(entries);
      final xyzGroup = grouped.firstWhere(
        (group) => group.canonicalKey == 'xyz.com',
      );

      expect(xyzGroup.displayName, 'XYZ');
      expect(xyzGroup.accountCount, 3);
    });

    test(
      'collapses tenant-style subdomains to the base registrable domain',
      () {
        final entries = [
          makeEntry(
            id: 'tenant-1',
            appName: 'Tenant',
            username: 'u1',
            url: 'https://team1.example.com',
          ),
          makeEntry(
            id: 'tenant-2',
            appName: 'Tenant',
            username: 'u2',
            url: 'https://example.com',
          ),
        ];

        final grouped = service.group(entries);
        expect(grouped.length, 1);
        final exampleGroup = grouped.firstWhere(
          (group) => group.canonicalKey == 'example.com',
        );
        expect(exampleGroup.accountCount, 2);
      },
    );

    test('parses android credential realm and prettifies app label', () {
      final entries = [
        makeEntry(
          id: 'android-1',
          appName: '',
          username: 'u1',
          url: 'android://abcdef12345@com.freelancer.android.messenger/',
        ),
        makeEntry(
          id: 'android-2',
          appName: '',
          username: 'u2',
          url: 'android://xyz987@com.freelancer.android.messenger/',
        ),
      ];

      final grouped = service.group(entries);
      final androidGroup = grouped.firstWhere(
        (group) =>
            group.canonicalKey == 'android:com.freelancer.android.messenger',
      );

      expect(androidGroup.displayName, 'Freelancer');
      expect(androidGroup.accountCount, 2);
    });

    test('prefers representative stored appName for group display label', () {
      final entries = [
        makeEntry(
          id: 'wish-web',
          appName: 'wish.com',
          username: 'u1',
          url: 'https://wish.com',
          lastUpdated: DateTime(2026, 1, 3),
        ),
        makeEntry(
          id: 'wish-android',
          appName: 'Wish',
          username: 'u2',
          url: 'android://hash@com.contextlogic.wish/',
          lastUpdated: DateTime(2026, 1, 4),
        ),
        makeEntry(
          id: 'wish-android-2',
          appName: 'Wish',
          username: 'u3',
          url: 'android://hash2@com.contextlogic.wish/',
          lastUpdated: DateTime(2026, 1, 5),
        ),
      ];

      final grouped = service.group(entries);
      final wishGroup = grouped.firstWhere(
        (group) => group.canonicalKey == 'android:com.contextlogic.wish',
      );

      expect(wishGroup.displayName, 'Wish');
      expect(wishGroup.accountCount, 2);
    });

    test(
      'uses stored appName over prettified package when appName is non-empty',
      () {
        final entries = [
          makeEntry(
            id: 'irctc-1',
            appName: 'IRCTC Rail Connect',
            username: 'dhruvanbhalara',
            url: 'android://someHash@com.cris.android/',
          ),
        ];

        final grouped = service.group(entries);
        final irctcGroup = grouped.firstWhere(
          (group) => group.canonicalKey == 'android:com.cris.android',
        );

        expect(irctcGroup.displayName, 'IRCTC Rail Connect');
        expect(irctcGroup.accountCount, 1);
      },
    );

    test('uses stored appName for contextlogic wish android entry', () {
      final entries = [
        makeEntry(
          id: 'wish-1',
          appName: 'Wish - Shopping Made Fun',
          username: 'user@example.com',
          url: 'android://someHash@com.contextlogic.wish/',
        ),
      ];

      final grouped = service.group(entries);
      final wishGroup = grouped.firstWhere(
        (group) => group.canonicalKey == 'android:com.contextlogic.wish',
      );

      expect(wishGroup.displayName, 'Wish - Shopping Made Fun');
    });

    test(
      'uses first appName when multiple accounts share the same android package',
      () {
        final entries = [
          makeEntry(
            id: 'fb-1',
            appName: 'Facebook',
            username: 'alice@example.com',
            url: 'android://hashA@com.facebook.katana/',
            lastUpdated: DateTime(2026, 1, 2),
          ),
          makeEntry(
            id: 'fb-2',
            appName: 'Facebook',
            username: 'bob@example.com',
            url: 'android://hashB@com.facebook.katana/',
            lastUpdated: DateTime(2026, 1, 1),
          ),
        ];

        final grouped = service.group(entries);
        final fbGroup = grouped.firstWhere(
          (group) => group.canonicalKey == 'android:com.facebook.katana',
        );

        expect(fbGroup.displayName, 'Facebook');
        expect(fbGroup.accountCount, 2);
      },
    );

    test(
      'falls back to prettified package when appName is only whitespace',
      () {
        final entries = [
          makeEntry(
            id: 'ws-1',
            appName: '   ',
            username: 'u1',
            url: 'android://hashXYZ@com.freelancer.android.messenger/',
          ),
        ];

        final grouped = service.group(entries);
        final group = grouped.firstWhere(
          (g) => g.canonicalKey == 'android:com.freelancer.android.messenger',
        );

        expect(group.displayName, 'Freelancer');
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

    group('Registrable domain collation tests', () {
      test('collapses deeply nested subdomains to base domain', () {
        final entries = [
          makeEntry(
            id: 'nested',
            appName: 'Nested',
            username: 'u1',
            url: 'https://a.b.c.example.com',
          ),
        ];
        final grouped = service.group(entries);
        expect(grouped.first.canonicalKey, 'example.com');
      });

      test(
        'handles common ccTLDs correctly recognizing the registry suffix',
        () {
          final entries = [
            makeEntry(
              id: 'cctld',
              appName: 'UK Site',
              username: 'u1',
              url: 'https://app.example.co.uk',
            ),
          ];
          final grouped = service.group(entries);
          expect(grouped.first.canonicalKey, 'example.co.uk');
        },
      );

      test('handles base level domains or local networks without failure', () {
        final entries = [
          makeEntry(
            id: 'local',
            appName: 'Local',
            username: 'u1',
            url: 'http://example.local',
          ),
          makeEntry(
            id: 'base',
            appName: 'Base',
            username: 'u2',
            url: 'https://example.com',
          ),
        ];
        final grouped = service.group(entries);
        expect(grouped.length, 2);
        expect(
          grouped.map((g) => g.canonicalKey),
          containsAll(['example.local', 'example.com']),
        );
      });

      test('collapses previously unhandled obscure subdomains perfectly', () {
        final entries = [
          makeEntry(
            id: 'obscure',
            appName: 'Obscure',
            username: 'u1',
            url: 'https://my-secret-tenant.example.com',
          ),
        ];
        final grouped = service.group(entries);
        expect(grouped.first.canonicalKey, 'example.com');
      });

      test('keeps different base domains strictly separate', () {
        final entries = [
          makeEntry(
            id: 'app1',
            appName: 'App1',
            username: 'u1',
            url: 'https://app.example1.com',
          ),
          makeEntry(
            id: 'app2',
            appName: 'App2',
            username: 'u2',
            url: 'https://app.example2.com',
          ),
        ];
        final grouped = service.group(entries);
        expect(grouped.length, 2);
        expect(
          grouped.map((g) => g.canonicalKey),
          containsAll(['example1.com', 'example2.com']),
        );
      });
    });

    group(
      'Android package prettification tests (without hardcoded overrides)',
      () {
        test('prettifies simple android package name missing appName', () {
          final entries = [
            makeEntry(
              id: 'simple',
              appName: '',
              username: 'u1',
              url: 'android://hash@com.freelancer.android.messenger/',
            ),
          ];
          final grouped = service.group(entries);
          expect(grouped.first.displayName, 'Freelancer');
        });

        test(
          'prettifies dot-separated names like cris.org.in.prs.ima gracefully',
          () {
            final entries = [
              makeEntry(
                id: 'cris',
                appName: '',
                username: 'u1',
                url: 'android://hash@cris.org.in.prs.ima/',
              ),
            ];
            final grouped = service.group(entries);
            expect(grouped.first.displayName, 'Cris');
          },
        );

        test('prettifies complex package with underscores and hyphens', () {
          final entries = [
            makeEntry(
              id: 'complex',
              appName: '',
              username: 'u1',
              url: 'android://hash@com.my_app-corp.mobile/',
            ),
          ];
          final grouped = service.group(entries);
          expect(grouped.first.displayName, 'My app corp');
        });

        test(
          'prettifies package containing the word android in different casing',
          () {
            final entries = [
              makeEntry(
                id: 'android-case',
                appName: '',
                username: 'u1',
                url: 'android://hash@com.AnDroiDCorp.app/',
              ),
            ];
            final grouped = service.group(entries);
            expect(grouped.first.displayName, 'Corp');
          },
        );

        test('returns raw package strictly if stripping leaves it empty', () {
          final entries = [
            makeEntry(
              id: 'empty',
              appName: '',
              username: 'u1',
              url: 'android://hash@com.android.org/',
            ),
          ];
          final grouped = service.group(entries);
          expect(grouped.first.displayName, 'com.android.org');
        });
      },
    );
  });
}
