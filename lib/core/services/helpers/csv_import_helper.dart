import 'package:csv/csv.dart';
import 'package:passvault/core/utils/app_logger.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

/// Helper class for parsing CSV content into [PasswordEntry] objects.
class CsvImportHelper {
  /// Parses CSV content and returns a list of [PasswordEntry] objects.
  static List<PasswordEntry> parse(String csvContent) {
    AppLogger.info('Starting CSV import', tag: 'CsvImportHelper');

    // Normalize line endings to avoid parsing issues
    final normalizedContent = csvContent
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n');
    AppLogger.debug(
      'CSV content length: ${normalizedContent.length} chars (normalized)',
      tag: 'CsvImportHelper',
    );

    // Try parsing with default settings
    var rows = const CsvToListConverter().convert(normalizedContent);
    AppLogger.debug(
      'Parsed ${rows.length} total rows including header',
      tag: 'CsvImportHelper',
    );

    if (rows.length <= 1) {
      AppLogger.warning(
        'CSV resulted in only ${rows.length} row(s). Trying manual line split for backup...',
        tag: 'CsvImportHelper',
      );
      final lines = normalizedContent
          .split('\n')
          .where((l) => l.trim().isNotEmpty)
          .toList();
      if (lines.length > 1) {
        rows = lines
            .map((line) => const CsvToListConverter().convert(line).first)
            .toList();
        AppLogger.debug(
          'Second attempt (manual split) found ${rows.length} rows',
          tag: 'CsvImportHelper',
        );
      }
    }

    if (rows.isEmpty) {
      AppLogger.warning(
        'CSV content resulted in 0 rows',
        tag: 'CsvImportHelper',
      );
      return [];
    }

    final headers = rows[0]
        .map((h) => h.toString().toLowerCase().trim())
        .toList();
    AppLogger.debug('Detected headers: $headers', tag: 'CsvImportHelper');

    // Skip header row
    final dataRows = rows.skip(1).toList();
    AppLogger.debug(
      'Processing ${dataRows.length} data rows',
      tag: 'CsvImportHelper',
    );

    // Map column indices
    final appNameIdx = _findHeaderIdx(headers, [
      'name',
      'app',
      'application',
      'title',
      'app name',
    ]);
    final usernameIdx = _findHeaderIdx(headers, [
      'username',
      'email',
      'login',
      'user',
    ]);
    final passwordIdx = _findHeaderIdx(headers, ['password', 'pass', 'key']);
    final urlIdx = _findHeaderIdx(headers, ['url', 'website', 'link']);
    final notesIdx = _findHeaderIdx(headers, [
      'note',
      'notes',
      'comment',
      'extra',
    ]);
    final folderIdx = _findHeaderIdx(headers, [
      'folder',
      'group',
      'category',
      'collection',
    ]);
    final favIdx = _findHeaderIdx(headers, ['favorite', 'starred', 'fav']);

    final baseMicros = DateTime.now().microsecondsSinceEpoch;
    var counter = 0;

    final entries = <PasswordEntry>[];
    for (final row in dataRows) {
      if (row.length < 2) continue;

      final appName = appNameIdx != -1 && appNameIdx < row.length
          ? row[appNameIdx].toString()
          : row[0].toString();
      final username = usernameIdx != -1 && usernameIdx < row.length
          ? row[usernameIdx].toString()
          : (row.length > 1 ? row[1].toString() : '');
      final password = passwordIdx != -1 && passwordIdx < row.length
          ? row[passwordIdx].toString()
          : (row.length > 2 ? row[2].toString() : '');
      final url = urlIdx != -1 && urlIdx < row.length
          ? row[urlIdx].toString()
          : null;
      final notes = notesIdx != -1 && notesIdx < row.length
          ? row[notesIdx].toString()
          : null;
      final folder = folderIdx != -1 && folderIdx < row.length
          ? row[folderIdx].toString()
          : null;
      final favorite = favIdx != -1 && favIdx < row.length
          ? (row[favIdx].toString().toLowerCase() == 'true' ||
                row[favIdx].toString() == '1')
          : false;

      entries.add(
        PasswordEntry(
          id: '${baseMicros}_${counter++}',
          appName: appName,
          username: username,
          password: password,
          lastUpdated: DateTime.now(),
          url: url,
          notes: notes,
          folder: folder,
          favorite: favorite,
        ),
      );
    }

    AppLogger.info(
      'Created ${entries.length} valid PasswordEntry objects',
      tag: 'CsvImportHelper',
    );
    return entries;
  }

  static int _findHeaderIdx(List<String> headers, List<String> synonyms) {
    for (final synonym in synonyms) {
      final idx = headers.indexWhere(
        (h) => h == synonym || h.contains(synonym),
      );
      if (idx != -1) return idx;
    }
    return -1;
  }
}
