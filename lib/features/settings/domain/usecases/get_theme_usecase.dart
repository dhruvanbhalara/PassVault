import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';

@lazySingleton
class GetThemeUseCase {
  final SettingsRepository _repository;

  GetThemeUseCase(this._repository);

  Result<ThemeType> call() {
    return _repository.getTheme();
  }
}
