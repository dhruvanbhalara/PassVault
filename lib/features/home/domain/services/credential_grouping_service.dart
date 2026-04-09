import 'package:passvault/features/home/domain/entities/grouped_home_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

class CredentialGroupingService {
  const CredentialGroupingService();
  static const Set<String> _subdomainCollapsePrefixes = {
    'www',
    'm',
    'mobile',
    'accounts',
    'account',
    'auth',
    'login',
    'signin',
    'id',
    'app',
  };

  List<GroupedHomeEntry> group(List<PasswordEntry> credentials) {
    final groupedByCanonicalKey = <String, List<PasswordEntry>>{};
    final displayByCanonicalKey = <String, String>{};

    for (final credential in credentials) {
      final identity = _targetIdentityFor(credential);
      final canonicalKey = identity.canonicalKey;
      groupedByCanonicalKey.putIfAbsent(canonicalKey, () => []).add(credential);
      displayByCanonicalKey.putIfAbsent(
        canonicalKey,
        () => identity.displayName,
      );
    }

    final groupedEntries = groupedByCanonicalKey.entries.map((group) {
      final sortedMembers = [...group.value]..sort(_compareMemberEntries);
      return GroupedHomeEntry(
        canonicalKey: group.key,
        displayName: displayByCanonicalKey[group.key] ?? group.key,
        members: sortedMembers,
      );
    }).toList();

    groupedEntries.sort(_compareGroupedEntries);
    return groupedEntries;
  }

  String canonicalizeTarget(String target) {
    final trimmed = target.trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }

    final lowercased = trimmed.toLowerCase();
    final withoutScheme = lowercased.replaceFirst(RegExp(r'^https?://'), '');
    final withoutLeadingWww = withoutScheme.replaceFirst(RegExp(r'^www\.'), '');
    return withoutLeadingWww;
  }

  int _compareGroupedEntries(GroupedHomeEntry left, GroupedHomeEntry right) {
    final byDisplay = left.displayName.toLowerCase().compareTo(
      right.displayName.toLowerCase(),
    );
    if (byDisplay != 0) {
      return byDisplay;
    }

    return left.canonicalKey.compareTo(right.canonicalKey);
  }

  int _compareMemberEntries(PasswordEntry left, PasswordEntry right) {
    final byUsername = left.username.toLowerCase().compareTo(
      right.username.toLowerCase(),
    );
    if (byUsername != 0) {
      return byUsername;
    }

    final byUpdated = right.lastUpdated.compareTo(left.lastUpdated);
    if (byUpdated != 0) {
      return byUpdated;
    }

    return left.id.compareTo(right.id);
  }

  _TargetIdentity _targetIdentityFor(PasswordEntry entry) {
    final rawTarget = (entry.url ?? '').trim().isNotEmpty
        ? (entry.url ?? '').trim()
        : entry.appName.trim();
    final normalizedTarget = canonicalizeTarget(rawTarget);

    final androidPackage =
        _androidPackageFromRealm(normalizedTarget) ??
        _androidPackageLike(normalizedTarget);
    if (androidPackage != null && androidPackage.isNotEmpty) {
      final storedName = entry.appName.trim();
      return _TargetIdentity(
        canonicalKey: 'android:$androidPackage',
        displayName: storedName.isNotEmpty
            ? storedName
            : _prettifyPackageLabel(androidPackage),
      );
    }

    final host = _hostFromTarget(normalizedTarget);
    if (host != null && host.isNotEmpty) {
      return _TargetIdentity(canonicalKey: host, displayName: host);
    }

    final appName = entry.appName.trim();
    if (appName.isNotEmpty) {
      return _TargetIdentity(
        canonicalKey: canonicalizeTarget(appName),
        displayName: appName,
      );
    }

    return _TargetIdentity(canonicalKey: entry.id, displayName: entry.id);
  }

  String? _hostFromTarget(String normalizedTarget) {
    if (normalizedTarget.isEmpty) {
      return null;
    }
    if (normalizedTarget.contains(' ')) {
      return null;
    }
    final hasScheme = normalizedTarget.contains('://');
    final hasDomainHint = normalizedTarget.contains('.');
    if (!hasScheme && !hasDomainHint) {
      return null;
    }

    Uri? uri = Uri.tryParse(normalizedTarget);
    if (uri == null || uri.host.isEmpty) {
      uri = Uri.tryParse('https://$normalizedTarget');
    }
    if (uri == null || uri.host.isEmpty) {
      return null;
    }

    final normalizedHost = uri.host.toLowerCase().replaceFirst(
      RegExp(r'^www\.'),
      '',
    );
    return _canonicalWebHost(normalizedHost);
  }

  String _canonicalWebHost(String host) {
    final labels = host.split('.');
    if (labels.length <= 2) {
      return host;
    }

    final prefix = labels.first;
    if (_shouldCollapseSubdomain(prefix)) {
      return _registrableDomain(host);
    }

    return host;
  }

  bool _shouldCollapseSubdomain(String prefix) {
    if (_subdomainCollapsePrefixes.contains(prefix)) {
      return true;
    }

    // Handles common noisy prefixes like ww2.example.com or wwe.example.com.
    return RegExp(r'^ww[a-z0-9]*$').hasMatch(prefix);
  }

  String _registrableDomain(String host) {
    final labels = host.split('.');
    if (labels.length <= 2) {
      return host;
    }

    final last = labels[labels.length - 1];
    final secondLast = labels[labels.length - 2];
    final thirdLast = labels[labels.length - 3];
    final ccTldLike = {'uk', 'jp', 'au', 'nz', 'za', 'in', 'br'};
    final secondLevelSet = {'co', 'com', 'org', 'net', 'gov', 'ac', 'edu'};

    if (ccTldLike.contains(last) && secondLevelSet.contains(secondLast)) {
      return '$thirdLast.$secondLast.$last';
    }

    return '$secondLast.$last';
  }

  String? _androidPackageFromRealm(String normalizedTarget) {
    final match = RegExp(
      r'^android://[^@/]+@([^/]+)/?$',
      caseSensitive: false,
    ).firstMatch(normalizedTarget);
    return match?.group(1)?.trim().toLowerCase();
  }

  String? _androidPackageLike(String normalizedTarget) {
    if (normalizedTarget.startsWith('android:')) {
      return normalizedTarget.replaceFirst('android:', '').trim();
    }
    final packageRegex = RegExp(r'^[a-z0-9_]+(\.[a-z0-9_]+){2,}$');
    if (!packageRegex.hasMatch(normalizedTarget)) {
      return null;
    }

    final labels = normalizedTarget.split('.');
    if (labels.length < 3) {
      return null;
    }
    final knownTlds = {
      'com',
      'org',
      'net',
      'in',
      'co',
      'io',
      'dev',
      'app',
      'uk',
      'au',
      'jp',
      'br',
      'de',
      'fr',
      'us',
      'ca',
      'nl',
      'es',
      'it',
      'ru',
      'xyz',
    };
    if (knownTlds.contains(labels.last)) {
      return null;
    }

    return normalizedTarget;
  }

  String _prettifyPackageLabel(String packageName) {
    final segments = packageName
        .split('.')
        .where((segment) => segment.isNotEmpty);
    final filteredSegments = segments
        .where(
          (segment) => segment != 'com' && segment != 'org' && segment != 'net',
        )
        .toList();
    final candidate = filteredSegments.isEmpty
        ? packageName
        : filteredSegments.first;
    final sanitized = candidate
        .replaceAll(RegExp(r'[_-]+'), ' ')
        .replaceAll(RegExp(r'android', caseSensitive: false), '')
        .trim();
    if (sanitized.isEmpty) {
      return packageName;
    }
    return sanitized[0].toUpperCase() + sanitized.substring(1);
  }
}

class _TargetIdentity {
  final String canonicalKey;
  final String displayName;

  const _TargetIdentity({
    required this.canonicalKey,
    required this.displayName,
  });
}
