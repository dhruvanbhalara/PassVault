import 'dart:typed_data';

import 'package:passvault/core/services/data_service.dart';
import 'package:passvault/core/services/file_service.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

sealed class ImportPathResult {
  const ImportPathResult();
}

final class ImportPathEntries extends ImportPathResult {
  final List<PasswordEntry> entries;
  final List<PasswordGenerationStrategy>? strategies;
  const ImportPathEntries(this.entries, {this.strategies});
}

final class ImportPathRequiresPassword extends ImportPathResult {
  final String filePath;
  const ImportPathRequiresPassword(this.filePath);
}

final class ImportPathInvalidFormat extends ImportPathResult {
  const ImportPathInvalidFormat();
}

class ImportExportPathResolver {
  final FileService _fileService;
  final DataService _dataService;

  const ImportExportPathResolver(this._fileService, this._dataService);

  Future<ImportPathResult> resolve(String path, {String? password}) async {
    if (_isJson(path)) {
      final content = await _fileService.readAsString(path);
      final result = _dataService.importFromJson(content);
      return ImportPathEntries(result.passwords, strategies: result.strategies);
    }

    if (_isCsv(path)) {
      final content = await _fileService.readAsString(path);
      return ImportPathEntries(
        _dataService.importFromCsv(content),
        strategies: const [],
      );
    }

    if (_isEncryptedBackup(path)) {
      if (password == null) {
        return ImportPathRequiresPassword(path);
      }
      final encryptedData = await _fileService.readAsBytes(path);
      final result = _dataService.importFromEncrypted(
        Uint8List.fromList(encryptedData),
        password,
      );
      return ImportPathEntries(result.passwords, strategies: result.strategies);
    }

    return const ImportPathInvalidFormat();
  }

  bool _isEncryptedBackup(String path) {
    return path.toLowerCase().endsWith('.pvault');
  }

  bool _isJson(String path) => path.toLowerCase().endsWith('.json');

  bool _isCsv(String path) => path.toLowerCase().endsWith('.csv');
}

String generateExportFileName(String prefix, String extension) {
  final timestamp = DateTime.now()
      .toIso8601String()
      .replaceAll(':', '-')
      .split('.')
      .first;
  return '${prefix}_$timestamp.$extension';
}
