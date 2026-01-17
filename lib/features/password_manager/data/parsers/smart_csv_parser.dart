import 'package:csv/csv.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/utils/app_logger.dart';
import 'package:passvault/features/password_manager/domain/entities/import_source_type.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:uuid/uuid.dart';

/// Unified CSV parser with automatic format detection.
///
/// Intelligently detects CSV format from headers and flexibly maps
/// columns to PasswordEntry fields. Supports all major browsers and
/// password managers without requiring manual source selection.
@lazySingleton
class SmartCsvParser {
  final _uuid = const Uuid();

  /// Parse CSV content with automatic format detection.
  ///
  /// [csvContent]: Raw CSV file content as string
  /// [forceFormat]: Optional manual format override (skips auto-detection)
  ///
  /// Returns list of PasswordEntry objects parsed from CSV.
  /// Throws [ParsingException] if CSV is malformed or missing required fields.
  Future<List<PasswordEntry>> parse(
    String csvContent, {
    ImportSourceType? forceFormat,
  }) async {
    if (csvContent.trim().isEmpty) {
      throw ParsingException('CSV file is empty');
    }

    // Normalize line endings and parse CSV into rows
    final normalizedContent = csvContent
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n');
    final rows = const CsvToListConverter(eol: '\n').convert(normalizedContent);

    if (rows.isEmpty) {
      throw ParsingException('No data found in CSV file');
    }

    if (rows.length < 2) {
      throw ParsingException(
        'CSV must contain header row and at least one data row',
      );
    }

    // Extract headers (first row)
    final headers = rows.first
        .map((h) => h.toString().toLowerCase().trim())
        .toList();

    // Auto-detect format or use manual override
    final detectedFormat = forceFormat ?? _detectFormat(headers);

    // Extract data rows (skip header)
    final dataRows = rows.skip(1);

    // Parse each row into PasswordEntry
    final entries = <PasswordEntry>[];
    for (var i = 0; i < dataRows.length; i++) {
      final row = dataRows.elementAt(i);
      try {
        final entry = _parseRow(headers, row, detectedFormat);
        if (entry != null) {
          entries.add(entry);
        }
      } catch (e) {
        // Log error but continue parsing other rows
        AppLogger.warning(
          'Failed to parse CSV row ${i + 2}',
          tag: 'SmartCsvParser',
          error: e,
        );
      }
    }

    if (entries.isEmpty) {
      throw ParsingException('No valid password entries found in CSV');
    }

    return entries;
  }

  /// Detect CSV format by analyzing header patterns.
  ImportSourceType _detectFormat(List<String> headers) {
    final headerSet = headers.toSet();

    // Chrome/Edge/Safari: Exactly 3 columns (url, username, password)
    if (headers.length == 3 &&
        headerSet.contains('url') &&
        headerSet.contains('username') &&
        headerSet.contains('password')) {
      return ImportSourceType.chrome;
    }

    // Firefox: Contains unique Firefox fields
    if (headerSet.contains('httprealm') ||
        headerSet.contains('formactionorigin') ||
        headerSet.contains('guid')) {
      return ImportSourceType.firefox;
    }

    // Bitwarden: Contains Bitwarden-specific fields
    if (headerSet.contains('login_uri') ||
        headerSet.contains('login_username') ||
        headerSet.contains('login_password')) {
      return ImportSourceType.bitwarden;
    }

    // 1Password: Contains website field instead of url
    if (headerSet.contains('website') &&
        !headerSet.contains('url') &&
        headerSet.contains('password')) {
      return ImportSourceType.onePassword;
    }

    // LastPass: Contains 'extra' field for notes
    if (headerSet.contains('extra') && headerSet.contains('url')) {
      return ImportSourceType.lastPass;
    }

    // Fallback to generic parser
    return ImportSourceType.generic;
  }

  /// Parse a single CSV row into PasswordEntry.
  PasswordEntry? _parseRow(
    List<String> headers,
    List<dynamic> row,
    ImportSourceType format,
  ) {
    // Create header-to-value map
    final data = <String, String>{};
    for (var i = 0; i < headers.length && i < row.length; i++) {
      data[headers[i]] = row[i]?.toString().trim() ?? '';
    }

    // Extract fields using flexible column mapping
    final username = _findValue(data, [
      'username',
      'email',
      'login',
      'login_username',
      'user',
    ]);
    final password = _findValue(data, [
      'password',
      'pass',
      'login_password',
      'pwd',
    ]);

    // Skip rows without required fields
    if (username == null ||
        username.isEmpty ||
        password == null ||
        password.isEmpty) {
      return null;
    }

    // Extract URL
    final url = _findValue(data, [
      'url',
      'website',
      'site',
      'login_uri',
      'uri',
    ]);

    // Extract or generate appName
    String appName;
    final nameField = _findValue(data, ['name', 'title', 'appname', 'app']);
    if (url != null && url.isNotEmpty) {
      appName = _extractDomainFromUrl(url);
    } else if (nameField != null && nameField.isNotEmpty) {
      appName = nameField;
    } else {
      appName = username; // Fallback to username if no other option
    }

    // Extract optional fields
    final notes = _findValue(data, [
      'notes',
      'extra',
      'comment',
      'comments',
      'note',
    ]);
    final folder = _findValue(data, [
      'folder',
      'category',
      'group',
      'grouping',
    ]);
    final favoriteStr = _findValue(data, [
      'favorite',
      'starred',
      'favourite',
      'fav',
    ]);
    final favorite =
        favoriteStr != null &&
        (favoriteStr == '1' || favoriteStr.toLowerCase() == 'true');

    return PasswordEntry(
      id: _uuid.v4(),
      appName: appName,
      username: username,
      password: password,
      lastUpdated: DateTime.now(),
      url: url,
      notes: notes,
      folder: folder,
      favorite: favorite,
    );
  }

  /// Find first matching value from list of possible column names.
  String? _findValue(Map<String, String> data, List<String> possibleNames) {
    for (final name in possibleNames) {
      final value = data[name];
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  /// Extract domain from URL for appName.
  ///
  /// Examples:
  /// - https://github.com/login -> github.com
  /// - http://subdomain.test.org -> test.org
  String _extractDomainFromUrl(String url) {
    try {
      final uri = Uri.parse(url.contains('://') ? url : 'https://$url');
      var host = uri.host;

      if (host.isEmpty) return url;

      // Remove 'www.' prefix
      if (host.startsWith('www.')) {
        host = host.substring(4);
      }

      // If it's a subdomain (more than 2 parts), try to get the base domain
      // Simplistic approach for common TLDs
      final parts = host.split('.');
      if (parts.length > 2) {
        // Handle common double TLDs like .co.uk if necessary,
        // but for now just follow the test expectation of root domain.
        return '${parts[parts.length - 2]}.${parts[parts.length - 1]}';
      }

      return host;
    } catch (_) {
      return url;
    }
  }
}

/// Exception thrown during CSV parsing.
class ParsingException implements Exception {
  final String message;
  ParsingException(this.message);

  @override
  String toString() => 'ParsingException: $message';
}
