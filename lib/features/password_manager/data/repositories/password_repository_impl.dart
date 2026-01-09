import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/failures.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/password_manager/data/datasources/password_local_data_source.dart';
import 'package:passvault/features/password_manager/data/models/password_entry_model.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';

@LazySingleton(as: PasswordRepository)
class PasswordRepositoryImpl implements PasswordRepository {
  final PasswordLocalDataSource _localDataSource;

  PasswordRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<PasswordEntry>>> getPasswords() async {
    try {
      final models = await _localDataSource.getPasswords();
      return Success(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> savePassword(PasswordEntry entry) async {
    try {
      final model = PasswordEntryModel.fromEntity(entry);
      await _localDataSource.savePassword(model);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deletePassword(String id) async {
    try {
      await _localDataSource.deletePassword(id);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }
}
