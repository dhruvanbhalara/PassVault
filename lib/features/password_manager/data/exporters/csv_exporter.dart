import 'package:csv/csv.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

/// Exports passwords to PassVault's standardized CSV format.
///
/// WARNING: Exported CSV contains UNENCRYPTED passwords.
/// Users must be warned to handle files securely and delete after use.
@lazySingleton
class CsvExporter {
  /// Export passwords to CSV format.
  ///
  /// [entries]: List of password entries to export
  ///
  /// Returns CSV string with headers and all password data.
  String export(List<PasswordEntry> entries) {
    // Define CSV headers
    const headers = [
      'url',
      'username',
      'password',
      'appName',
      'notes',
      'folder',
      'favorite',
      'lastUpdated',
    ];

    // Convert entries to rows
    final rows = <List<String>>[
      headers, // Header row
      ...entries.map(_entryToRow), // Data rows
    ];

    // Convert to CSV string
    final csvContent = const ListToCsvConverter().convert(rows);
    return csvContent.isEmpty ? '' : '$csvContent\n';
  }

  /// Convert a PasswordEntry to a CSV row.
  List<String> _entryToRow(PasswordEntry entry) {
    return [
      entry.url ?? '',
      entry.username,
      entry.password,
      entry.appName,
      entry.notes ?? '',
      entry.folder ?? '',
      entry.favorite.toString(),
      entry.lastUpdated.toIso8601String(),
    ];
  }
}
