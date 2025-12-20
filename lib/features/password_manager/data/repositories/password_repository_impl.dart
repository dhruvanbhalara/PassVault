import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/data/datasources/password_local_data_source.dart';
import 'package:passvault/features/password_manager/data/models/password_entry_model.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';

@LazySingleton(as: PasswordRepository)
class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordLocalDataSource _localDataSource;

  PasswordRepositoryImpl(this._localDataSource);

  @override
  Future<List<PasswordEntry>> getPasswords() async {
    final models = await _localDataSource.getPasswords();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> savePassword(PasswordEntry entry) async {
    final model = PasswordEntryModel.fromEntity(entry);
    await _localDataSource.savePassword(model);
  }

  @override
  Future<void> deletePassword(String id) async {
    await _localDataSource.deletePassword(id);
  }
}
