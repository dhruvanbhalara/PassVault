import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/services/crypto_service.dart';
import 'package:passvault/core/utils/app_logger.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Service for exporting and importing password data.
///
/// Supports both plaintext (JSON/CSV) and encrypted exports for secure
/// data portability between devices.
@lazySingleton
class DataService {
  final CryptoService _cryptoService;

  DataService(this._cryptoService);

  /// Exports password entries as a JSON file using system share.
  Future<void> exportToJson(List<PasswordEntry> entries) async {
    final jsonString = generateJson(entries);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/passvault_export.json');
    await file.writeAsString(jsonString);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'PassVault Data Export (JSON)',
      ),
    );
  }

  /// Generates JSON string from entries.
  String generateJson(List<PasswordEntry> entries) {
    final jsonList = entries.map((e) => e.toJson()).toList();
    return jsonEncode(jsonList);
  }

  /// Exports password entries as a CSV file using system share.
  Future<void> exportToCsv(List<PasswordEntry> entries) async {
    final csvData = generateCsv(entries);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/passvault_export.csv');
    await file.writeAsString(csvData);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'PassVault Data Export (CSV)',
      ),
    );
  }

  /// Generates CSV string from entries.
  String generateCsv(List<PasswordEntry> entries) {
    List<List<dynamic>> rows = [];
    // Header
    rows.add(['App Name', 'Username', 'Password', 'Last Updated']);
    for (var entry in entries) {
      rows.add([
        entry.appName,
        entry.username,
        entry.password,
        entry.lastUpdated.toIso8601String(),
      ]);
    }
    return const ListToCsvConverter().convert(rows);
  }

  /// Exports password entries as an encrypted file using system share.
  Future<void> exportToEncryptedJson(
    List<PasswordEntry> entries,
    String password,
  ) async {
    final encrypted = generateEncryptedJson(entries, password);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/passvault_export.pvault');
    await file.writeAsBytes(encrypted);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'PassVault Encrypted Export',
      ),
    );
  }

  /// Generates encrypted bytes from entries.
  Uint8List generateEncryptedJson(
    List<PasswordEntry> entries,
    String password,
  ) {
    final jsonString = generateJson(entries);
    return _cryptoService.encryptWithPassword(
      Uint8List.fromList(utf8.encode(jsonString)),
      password,
    );
  }

  /// Imports password entries from a JSON string.
  List<PasswordEntry> importFromJson(String jsonContent) {
    final List<dynamic> decoded = jsonDecode(jsonContent);
    return decoded
        .map((item) => PasswordEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Imports password entries from a CSV string.
  List<PasswordEntry> importFromCsv(String csvContent) {
    AppLogger.info('Starting CSV import', tag: 'DataService');

    // Normalize line endings to avoid parsing issues
    final normalizedContent = csvContent
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n');
    AppLogger.debug(
      'CSV content length: ${normalizedContent.length} chars (normalized)',
      tag: 'DataService',
    );

    // Try parsing with default settings
    var rows = const CsvToListConverter().convert(normalizedContent);
    AppLogger.debug(
      'Parsed ${rows.length} total rows including header',
      tag: 'DataService',
    );

    if (rows.length <= 1) {
      AppLogger.warning(
        'CSV resulted in only ${rows.length} row(s). Trying manual line split for backup...',
        tag: 'DataService',
      );
      // If parsing failed to see rows, try a simpler approach for standard CSVs
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
          tag: 'DataService',
        );
      }
    }

    if (rows.isEmpty) {
      AppLogger.warning('CSV content resulted in 0 rows', tag: 'DataService');
      return [];
    }

    final headers = rows[0]
        .map((h) => h.toString().toLowerCase().trim())
        .toList();
    AppLogger.debug('Detected headers: $headers', tag: 'DataService');

    // Skip header row
    final dataRows = rows.skip(1).toList();
    AppLogger.debug(
      'Processing ${dataRows.length} data rows',
      tag: 'DataService',
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
    final favIdx = _findHeaderIdx(headers, ['favorite', 'starred', 'fav']);

    // Use microseconds + counter for guaranteed unique IDs within this import
    final baseMicros = DateTime.now().microsecondsSinceEpoch;
    var counter = 0;

    final entries = <PasswordEntry>[];
    for (final row in dataRows) {
      if (row.length < 2) continue; // Skip totally empty/broken rows

      // Get values based on detected indices or defaults
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
          favorite: favorite,
        ),
      );
    }

    AppLogger.info(
      'Created ${entries.length} valid PasswordEntry objects',
      tag: 'DataService',
    );
    return entries;
  }

  int _findHeaderIdx(List<String> headers, List<String> synonyms) {
    for (final synonym in synonyms) {
      final idx = headers.indexWhere(
        (h) => h == synonym || h.contains(synonym),
      );
      if (idx != -1) return idx;
    }
    return -1;
  }

  /// Imports password entries from an encrypted `.pvault` file.
  ///
  /// Requires the same password used during export.
  /// Throws [StateError] if the password is incorrect.
  List<PasswordEntry> importFromEncrypted(
    Uint8List encryptedData,
    String password,
  ) {
    final decrypted = _cryptoService.decryptWithPassword(
      encryptedData,
      password,
    );
    final jsonString = utf8.decode(decrypted);
    return importFromJson(jsonString);
  }
}
