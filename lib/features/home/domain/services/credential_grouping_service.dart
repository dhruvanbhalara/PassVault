import 'package:passvault/features/home/domain/entities/grouped_home_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

class CredentialGroupingService {
  const CredentialGroupingService();

  List<GroupedHomeEntry> group(List<PasswordEntry> credentials) {
    final groupedByCanonicalKey = <String, List<PasswordEntry>>{};
    final displayByCanonicalKey = <String, String>{};

    for (final credential in credentials) {
      final canonicalKey = _canonicalKeyFor(credential);
      groupedByCanonicalKey.putIfAbsent(canonicalKey, () => []).add(credential);
      displayByCanonicalKey.putIfAbsent(
        canonicalKey,
        () => _displayNameFor(credential, canonicalKey),
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

  String _canonicalKeyFor(PasswordEntry entry) {
    final normalizedUrl = canonicalizeTarget(entry.url ?? '');
    if (normalizedUrl.isNotEmpty) {
      return normalizedUrl;
    }

    final normalizedAppName = canonicalizeTarget(entry.appName);
    if (normalizedAppName.isNotEmpty) {
      return normalizedAppName;
    }

    return entry.id;
  }

  String _displayNameFor(PasswordEntry entry, String fallbackCanonical) {
    final normalizedUrl = canonicalizeTarget(entry.url ?? '');
    if (normalizedUrl.isNotEmpty) {
      return normalizedUrl;
    }

    final appName = entry.appName.trim();
    if (appName.isNotEmpty) {
      return appName;
    }

    return fallbackCanonical;
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
}
