// ignore: unused_import
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

abstract class PasswordRepository {
  Future<List<PasswordEntry>> getPasswords();
  Future<void> savePassword(PasswordEntry entry);
  Future<void> deletePassword(String id);
}
