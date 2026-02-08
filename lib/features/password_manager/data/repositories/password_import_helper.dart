import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/domain/entities/import_result.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

class PasswordImportHelper {
  static ImportResult detectDuplicates(
    List<PasswordEntry> entries,
    List<PasswordEntry> existing,
  ) {
    final duplicates = <DuplicatePasswordEntry>[];
    final toImport = <PasswordEntry>[];

    for (final entry in entries) {
      final duplicate = existing.firstWhere(
        (e) => e.appName == entry.appName && e.username == entry.username,
        orElse: () => entry,
      );

      if (duplicate != entry) {
        duplicates.add(
          DuplicatePasswordEntry(
            existingEntry: duplicate,
            newEntry: entry,
            conflictReason: 'Same appName and username',
          ),
        );
      } else {
        toImport.add(entry);
      }
    }

    return ImportResult(
      totalRecords: entries.length,
      successfulImports: toImport.length,
      failedImports: 0,
      duplicateEntries: duplicates,
      errors: [],
    );
  }

  static List<PasswordEntry> getUniqueEntriesToImport(
    ImportResult result,
    List<PasswordEntry> allEntries,
  ) {
    final duplicateNewEntries = result.duplicateEntries
        .map((e) => e.newEntry)
        .toSet();
    return allEntries.where((e) => !duplicateNewEntries.contains(e)).toList();
  }

  static PasswordEntry resolveDuplicate(DuplicatePasswordEntry resolution) {
    switch (resolution.userChoice) {
      case DuplicateResolutionChoice.replaceWithNew:
        return PasswordEntry(
          id: resolution.existingEntry.id,
          appName: resolution.newEntry.appName,
          username: resolution.newEntry.username,
          password: resolution.newEntry.password,
          lastUpdated: DateTime.now(),
          url: resolution.newEntry.url,
          notes: resolution.newEntry.notes,
          folder: resolution.newEntry.folder,
          favorite: resolution.newEntry.favorite,
        );
      case DuplicateResolutionChoice.keepBoth:
        return PasswordEntry(
          id: resolution.newEntry.id,
          appName: '${resolution.newEntry.appName} (imported)',
          username: resolution.newEntry.username,
          password: resolution.newEntry.password,
          lastUpdated: resolution.newEntry.lastUpdated,
          url: resolution.newEntry.url,
          notes: resolution.newEntry.notes,
          folder: resolution.newEntry.folder,
          favorite: resolution.newEntry.favorite,
        );
      case DuplicateResolutionChoice.keepExisting:
      case null:
        throw ArgumentError(
          'Cannot resolve duplicate with keepExisting or null choice',
        );
    }
  }
}
