import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/services/crypto_service.dart';
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

  /// Exports password entries as a JSON file.
  Future<void> exportToJson(List<PasswordEntry> entries) async {
    final jsonList = entries.map((e) => e.toJson()).toList();
    final jsonString = jsonEncode(jsonList);

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

  /// Exports password entries as a CSV file.
  Future<void> exportToCsv(List<PasswordEntry> entries) async {
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

    String csvData = const ListToCsvConverter().convert(rows);

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

  /// Exports password entries as an encrypted file.
  ///
  /// Uses AES-256-GCM encryption with a user-provided password.
  /// The exported file has a `.pvault` extension.
  Future<void> exportToEncryptedJson(
    List<PasswordEntry> entries,
    String password,
  ) async {
    final jsonList = entries.map((e) => e.toJson()).toList();
    final jsonString = jsonEncode(jsonList);

    // Encrypt the JSON data
    final encrypted = _cryptoService.encryptWithPassword(
      Uint8List.fromList(utf8.encode(jsonString)),
      password,
    );

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

  /// Imports password entries from a JSON string.
  List<PasswordEntry> importFromJson(String jsonContent) {
    final List<dynamic> decoded = jsonDecode(jsonContent);
    return decoded
        .map((item) => PasswordEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Imports password entries from a CSV string.
  List<PasswordEntry> importFromCsv(String csvContent) {
    final List<List<dynamic>> rows = const CsvToListConverter().convert(
      csvContent,
    );
    if (rows.isEmpty) return [];

    // Skip header
    final dataRows = rows.skip(1);

    return dataRows.map((row) {
      return PasswordEntry(
        id:
            DateTime.now().millisecondsSinceEpoch.toString() +
            row[0].toString(),
        appName: row[0].toString(),
        username: row[1].toString(),
        password: row[2].toString(),
        lastUpdated: DateTime.tryParse(row[3].toString()) ?? DateTime.now(),
      );
    }).toList();
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
