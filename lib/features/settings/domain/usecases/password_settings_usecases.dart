import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';

@lazySingleton
class GetPasswordGenerationSettingsUseCase {
  final SettingsRepository _repository;

  GetPasswordGenerationSettingsUseCase(this._repository);

  Result<PasswordGenerationSettings> call() {
    return _repository.getPasswordGenerationSettings();
  }
}

@lazySingleton
class SavePasswordGenerationSettingsUseCase {
  final SettingsRepository _repository;

  SavePasswordGenerationSettingsUseCase(this._repository);

  Future<Result<void>> call(PasswordGenerationSettings settings) async {
    return _repository.savePasswordGenerationSettings(settings);
  }
}
