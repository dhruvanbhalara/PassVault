class CredentialTargetParser {
  const CredentialTargetParser();

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

  String? hostFromTarget(String normalizedTarget) {
    if (normalizedTarget.isEmpty || normalizedTarget.contains(' ')) {
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

  String? androidPackageFromRealm(String normalizedTarget) {
    final match = RegExp(
      r'^android://[^@/]+@([^/]+)/?$',
      caseSensitive: false,
    ).firstMatch(normalizedTarget);
    return match?.group(1)?.trim().toLowerCase();
  }

  String? androidPackageLike(String normalizedTarget) {
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

  String prettifyPackageLabel(String packageName) {
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

  String _canonicalWebHost(String host) {
    return _registrableDomain(host);
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
}
