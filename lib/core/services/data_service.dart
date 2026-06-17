import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/services/crypto_service.dart';
import 'package:passvault/core/services/helpers/csv_import_helper.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
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
  Future<void> exportToJson(
    List<PasswordEntry> entries, {
    required String subject,
  }) async {
    final jsonString = generateJson(entries);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/passvault_export.json');
    await file.writeAsString(jsonString);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: subject),
    );
  }

  /// Generates JSON string from entries and optional strategies.
  String generateJson(
    List<PasswordEntry> entries, {
    List<PasswordGenerationStrategy>? strategies,
  }) {
    if (strategies == null || strategies.isEmpty) {
      final jsonList = entries.map((e) => e.toJson()).toList();
      return jsonEncode(jsonList);
    }

    final payload = {
      'passwords': entries.map((e) => e.toJson()).toList(),
      'strategies': strategies.map((e) => e.toJson()).toList(),
    };
    return jsonEncode(payload);
  }

  /// Exports password entries as a CSV file using system share.
  Future<void> exportToCsv(
    List<PasswordEntry> entries, {
    required String subject,
  }) async {
    final csvData = generateCsv(entries);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/passvault_export.csv');
    await file.writeAsString(csvData);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: subject),
    );
  }

  /// Generates CSV string from entries.
  String generateCsv(List<PasswordEntry> entries) {
    List<List<dynamic>> rows = [];
    // Header
    rows.add([
      'App Name',
      'Username',
      'Password',
      'URL',
      'Notes',
      'Folder',
      'Last Updated',
    ]);
    for (var entry in entries) {
      rows.add([
        entry.appName,
        entry.username,
        entry.password,
        entry.url ?? '',
        entry.notes ?? '',
        entry.folder ?? '',
        entry.lastUpdated.toIso8601String(),
      ]);
    }
    return const ListToCsvConverter().convert(rows);
  }

  /// Exports password entries as an encrypted file using system share.
  Future<void> exportToEncryptedJson(
    List<PasswordEntry> entries,
    String password, {
    required String subject,
  }) async {
    final encrypted = generateEncryptedJson(entries, password);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/passvault_export.pvault');
    await file.writeAsBytes(encrypted);

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: subject),
    );
  }

  /// Generates encrypted bytes from entries and optional strategies.
  Uint8List generateEncryptedJson(
    List<PasswordEntry> entries,
    String password, {
    List<PasswordGenerationStrategy>? strategies,
  }) {
    final jsonString = generateJson(entries, strategies: strategies);
    return _cryptoService.encryptWithPassword(
      Uint8List.fromList(utf8.encode(jsonString)),
      password,
    );
  }

  /// Imports password entries and strategies from a JSON string.
  ({List<PasswordEntry> passwords, List<PasswordGenerationStrategy> strategies})
  importFromJson(String jsonContent) {
    final decoded = jsonDecode(jsonContent);
    if (decoded is List) {
      final passwords = decoded
          .map((item) => PasswordEntry.fromJson(item as Map<String, dynamic>))
          .toList();
      return (
        passwords: passwords,
        strategies: const <PasswordGenerationStrategy>[],
      );
    } else if (decoded is Map) {
      final passwordsList = decoded['passwords'] as List<dynamic>? ?? [];
      final strategiesList = decoded['strategies'] as List<dynamic>? ?? [];

      final passwords = passwordsList
          .map(
            (item) =>
                PasswordEntry.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
      final strategies = strategiesList
          .map(
            (item) => PasswordGenerationStrategy.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();

      return (passwords: passwords, strategies: strategies);
    }
    return (
      passwords: const <PasswordEntry>[],
      strategies: const <PasswordGenerationStrategy>[],
    );
  }

  /// Imports password entries from a CSV string.
  List<PasswordEntry> importFromCsv(String csvContent) {
    return CsvImportHelper.parse(csvContent);
  }

  /// Imports password entries and strategies from an encrypted `.pvault` file.
  ///
  /// Requires the same password used during export.
  /// Throws [StateError] if the password is incorrect.
  ({List<PasswordEntry> passwords, List<PasswordGenerationStrategy> strategies})
  importFromEncrypted(Uint8List encryptedData, String password) {
    final decrypted = _cryptoService.decryptWithPassword(
      encryptedData,
      password,
    );
    final jsonString = utf8.decode(decrypted);
    return importFromJson(jsonString);
  }
}
