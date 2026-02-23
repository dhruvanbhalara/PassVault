import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/services/file_picker_service.dart';

@LazySingleton(as: IFilePickerService)
class FilePickerServiceImpl implements IFilePickerService {
  @visibleForTesting
  FileSaver fileSaver = FileSaver.instance;

  @override
  Future<String?> pickSavePath({
    required String fileName,
    required List<int> bytes,
    List<String>? allowedExtensions,
  }) async {
    try {
      // Use file_saver for cross-platform file saving with native dialogs
      // This handles Android SAF, iOS Document Picker, and desktop save dialogs
      final ext = _extractExtension(fileName, allowedExtensions);
      final mimeType = _getMimeType(ext);

      final path = await fileSaver.saveAs(
        name: _removeExtension(fileName, ext),
        bytes: Uint8List.fromList(bytes),
        fileExtension: ext,
        mimeType: mimeType,
      );

      return path;
    } catch (e) {
      // User cancelled or error occurred
      return null;
    }
  }

  @override
  Future<String?> pickFile({List<String>? allowedExtensions}) async {
    final useCustomType = _shouldUseCustomType(allowedExtensions);
    final result = await FilePicker.platform.pickFiles(
      type: useCustomType ? FileType.custom : FileType.any,
      allowedExtensions: useCustomType ? allowedExtensions : null,
    );
    return result?.files.single.path;
  }

  @override
  Future<String?> pickDirectory() async {
    return await FilePicker.platform.getDirectoryPath();
  }

  /// Extracts the file extension from the filename or allowed extensions.
  String _extractExtension(String fileName, List<String>? allowedExtensions) {
    if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
      return allowedExtensions.first;
    }

    final parts = fileName.split('.');
    if (parts.length > 1) {
      return parts.last;
    }

    return '';
  }

  bool _shouldUseCustomType(List<String>? allowedExtensions) {
    if (allowedExtensions == null || allowedExtensions.isEmpty) {
      return false;
    }

    const safeCustomExtensions = {'json', 'csv'};
    return allowedExtensions
        .map((extension) => extension.toLowerCase())
        .every(safeCustomExtensions.contains);
  }

  /// Removes the extension from the filename.
  String _removeExtension(String fileName, String ext) {
    if (ext.isEmpty) return fileName;
    if (fileName.endsWith('.$ext')) {
      return fileName.substring(0, fileName.length - ext.length - 1);
    }
    return fileName;
  }

  /// Determines the MIME type based on file extension.
  MimeType _getMimeType(String ext) {
    switch (ext.toLowerCase()) {
      case 'json':
        return MimeType.json;
      case 'csv':
        return MimeType.csv;
      case 'pvault':
      case 'dat':
        return MimeType.other;
      default:
        return MimeType.other;
    }
  }
}
