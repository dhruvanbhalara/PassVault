import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

@lazySingleton
class DataService {
  Future<void> exportToJson(List<PasswordEntry> entries) async {
    final jsonList = entries.map((e) => e.toJson()).toList();
    final jsonString = jsonEncode(jsonList);

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/passvault_export.json');
    await file.writeAsString(jsonString);

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'PassVault Data Export (JSON)');
  }

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

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'PassVault Data Export (CSV)');
  }

  List<PasswordEntry> importFromJson(String jsonContent) {
    final List<dynamic> decoded = jsonDecode(jsonContent);
    return decoded
        .map((item) => PasswordEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

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
}
