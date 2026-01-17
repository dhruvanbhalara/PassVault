import 'dart:async';

/// Interface for file picking and saving operations.
/// Abstracted to adhere to Clean Architecture principles.
abstract class IFilePickerService {
  /// Prompts the user to select a location to save a file.
  ///
  /// [fileName] is the suggested name for the file.
  /// [bytes] are the file contents to be saved (required for cross-platform support).
  /// [allowedExtensions] can be used to filter selectable file types.
  /// Returns the selected file path, or null if canceled.
  ///
  /// NOTE: On Android/iOS, this uses native SAF/Document Picker dialogs.
  /// The [bytes] parameter is required for proper cross-platform operation.
  Future<String?> pickSavePath({
    required String fileName,
    required List<int> bytes,
    List<String>? allowedExtensions,
  });

  /// Prompts the user to pick one or more files.
  ///
  /// [allowedExtensions] can be used to filter selectable file types.
  /// Returns the path of the selected file, or null if canceled.
  Future<String?> pickFile({List<String>? allowedExtensions});

  /// Prompts the user to select a directory.
  ///
  /// Returns the path of the selected directory, or null if canceled.
  Future<String?> pickDirectory();
}
