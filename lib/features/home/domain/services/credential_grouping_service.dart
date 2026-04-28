import 'package:passvault/features/home/domain/entities/grouped_home_entry.dart';
import 'package:passvault/features/home/domain/services/credential_target_parser.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

class CredentialGroupingService {
  const CredentialGroupingService();

  static const CredentialTargetParser _targetParser = CredentialTargetParser();

  List<GroupedHomeEntry> group(List<PasswordEntry> credentials) {
    final groupedByCanonicalKey = <String, List<PasswordEntry>>{};

    for (final credential in credentials) {
      final canonicalKey = _targetIdentityFor(credential).canonicalKey;
      groupedByCanonicalKey.putIfAbsent(canonicalKey, () => []).add(credential);
    }

    final groupedEntries = groupedByCanonicalKey.entries.map((group) {
      final sortedMembers = [...group.value]..sort(_compareMemberEntries);
      return GroupedHomeEntry(
        canonicalKey: group.key,
        displayName: _displayNameForGroup(group.key, sortedMembers),
        members: sortedMembers,
      );
    }).toList();

    groupedEntries.sort(_compareGroupedEntries);
    return groupedEntries;
  }

  String canonicalizeTarget(String target) =>
      _targetParser.canonicalizeTarget(target);

  String _displayNameForGroup(
    String canonicalKey,
    List<PasswordEntry> members,
  ) {
    final storedAppName = _bestStoredAppName(members);
    if (storedAppName != null) {
      return storedAppName;
    }

    if (canonicalKey.startsWith('android:')) {
      final packageName = canonicalKey.replaceFirst('android:', '');
      if (packageName.isNotEmpty) {
        return _targetParser.prettifyPackageLabel(packageName);
      }
    }

    return canonicalKey;
  }

  String? _bestStoredAppName(List<PasswordEntry> members) {
    final statsByName = <String, _NameStats>{};

    for (final member in members) {
      final appName = member.appName.trim();
      if (appName.isEmpty) {
        continue;
      }

      final key = appName.toLowerCase();
      final existing = statsByName[key];
      if (existing == null) {
        statsByName[key] = _NameStats(
          displayName: appName,
          count: 1,
          lastUpdated: member.lastUpdated,
        );
        continue;
      }

      final shouldReplaceDisplay = member.lastUpdated.isAfter(
        existing.lastUpdated,
      );
      statsByName[key] = _NameStats(
        displayName: shouldReplaceDisplay ? appName : existing.displayName,
        count: existing.count + 1,
        lastUpdated: shouldReplaceDisplay
            ? member.lastUpdated
            : existing.lastUpdated,
      );
    }

    if (statsByName.isEmpty) {
      return null;
    }

    final candidates = statsByName.entries.toList()
      ..sort((left, right) {
        final byCount = right.value.count.compareTo(left.value.count);
        if (byCount != 0) return byCount;

        final byUpdated = right.value.lastUpdated.compareTo(
          left.value.lastUpdated,
        );
        if (byUpdated != 0) return byUpdated;

        return left.key.compareTo(right.key);
      });

    return candidates.first.value.displayName;
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
        _targetParser.androidPackageFromRealm(normalizedTarget) ??
        _targetParser.androidPackageLike(normalizedTarget);
    if (androidPackage != null && androidPackage.isNotEmpty) {
      return _TargetIdentity(canonicalKey: 'android:$androidPackage');
    }

    final host = _targetParser.hostFromTarget(normalizedTarget);
    if (host != null && host.isNotEmpty) {
      return _TargetIdentity(canonicalKey: host);
    }

    final appName = entry.appName.trim();
    if (appName.isNotEmpty) {
      return _TargetIdentity(canonicalKey: canonicalizeTarget(appName));
    }

    return _TargetIdentity(canonicalKey: entry.id);
  }
}

class _TargetIdentity {
  final String canonicalKey;

  const _TargetIdentity({required this.canonicalKey});
}

class _NameStats {
  final String displayName;
  final int count;
  final DateTime lastUpdated;

  const _NameStats({
    required this.displayName,
    required this.count,
    required this.lastUpdated,
  });
}
