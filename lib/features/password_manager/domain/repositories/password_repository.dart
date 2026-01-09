import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

abstract class PasswordRepository {
  Future<Result<List<PasswordEntry>>> getPasswords();
  Future<Result<void>> savePassword(PasswordEntry entry);
  Future<Result<void>> deletePassword(String id);
}
