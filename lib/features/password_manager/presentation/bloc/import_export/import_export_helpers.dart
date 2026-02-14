import 'dart:typed_data';

import 'package:passvault/core/services/file_picker_service.dart';
import 'package:passvault/core/utils/app_logger.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/usecases/import_passwords_usecase.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_state.dart';

Future<ImportExportState> saveExportResult({
  required IFilePickerService filePickerService,
  required String fileName,
  required Uint8List bytes,
  required List<String> extensions,
}) async {
  final destinationPath = await filePickerService.pickSavePath(
    fileName: fileName,
    bytes: bytes,
    allowedExtensions: extensions,
  );
  if (destinationPath == null) {
    return const ImportExportInitial();
  }
  return ExportSuccess(destinationPath);
}

ImportExportFailure buildImportExportFailure({
  required String message,
  required Object error,
  required DataMigrationError errorType,
}) {
  AppLogger.error(message, tag: 'ImportExportBloc', error: error);
  return ImportExportFailure(errorType, error.toString());
}

Future<ImportExportState> resolveImportState({
  required ImportPasswordsUseCase importPasswordsUseCase,
  required List<PasswordEntry> entries,
}) async {
  final result = await importPasswordsUseCase(entries);
  return result.fold(
    (failure) =>
        ImportExportFailure(DataMigrationError.importFailed, failure.message),
    (importResult) {
      if (importResult.hasDuplicates) {
        return DuplicatesDetected(
          duplicates: importResult.duplicateEntries,
          successfulImports: importResult.successfulImports,
        );
      }
      return ImportSuccess(importResult.successfulImports);
    },
  );
}
