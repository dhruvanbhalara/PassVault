import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';

@lazySingleton
class GetOnboardingCompleteUseCase {
  final SettingsRepository _repository;

  GetOnboardingCompleteUseCase(this._repository);

  Result<bool> call() {
    return _repository.getOnboardingComplete();
  }
}

@lazySingleton
class SetOnboardingCompleteUseCase {
  final SettingsRepository _repository;

  SetOnboardingCompleteUseCase(this._repository);

  Future<Result<void>> call(bool complete) async {
    return _repository.setOnboardingComplete(complete);
  }
}

@lazySingleton
class GetOnboardingStepUseCase {
  final SettingsRepository _repository;

  GetOnboardingStepUseCase(this._repository);

  Result<int> call() {
    return _repository.getOnboardingStep();
  }
}

@lazySingleton
class SetOnboardingStepUseCase {
  final SettingsRepository _repository;

  SetOnboardingStepUseCase(this._repository);

  Future<Result<void>> call(int step) async {
    return _repository.saveOnboardingStep(step);
  }
}

@lazySingleton
class DeleteOnboardingStepUseCase {
  final SettingsRepository _repository;

  DeleteOnboardingStepUseCase(this._repository);

  Future<Result<void>> call() async {
    return _repository.deleteOnboardingStep();
  }
}
