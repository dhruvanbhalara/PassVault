import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';

@lazySingleton
class GetBiometricsEnabledUseCase {
  final SettingsRepository _repository;

  GetBiometricsEnabledUseCase(this._repository);

  Result<bool> call() {
    return _repository.getBiometricsEnabled();
  }
}

@lazySingleton
class SetBiometricsEnabledUseCase {
  final SettingsRepository _repository;

  SetBiometricsEnabledUseCase(this._repository);

  Future<Result<void>> call(bool enabled) async {
    return _repository.setBiometricsEnabled(enabled);
  }
}
