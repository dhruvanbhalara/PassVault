import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/domain/services/password_engine_service.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

@lazySingleton
class GeneratePasswordUseCase {
  final PasswordEngineService _passwordEngineService;

  GeneratePasswordUseCase(this._passwordEngineService);

  String call({required PasswordGenerationStrategy strategy}) {
    return _passwordEngineService.generatePassword(strategy: strategy);
  }
}
