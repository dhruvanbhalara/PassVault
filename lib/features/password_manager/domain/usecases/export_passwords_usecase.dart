import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';

/// Use case for exporting passwords to CSV format.
///
/// WARNING: Exported data is UNENCRYPTED. Users should be warned
/// to handle the export file securely and delete it after use.
@lazySingleton
class ExportPasswordsUseCase {
  final PasswordRepository _repository;

  ExportPasswordsUseCase(this._repository);

  /// Export all passwords to CSV format.
  ///
  /// [format]: Output format (default: 'csv')
  ///
  /// Returns CSV string with headers: url, username, password, appName,
  /// notes, folder, favorite, lastUpdated
  Future<Result<String>> call({String format = 'csv'}) {
    return _repository.exportPasswords(format: format);
  }
}
