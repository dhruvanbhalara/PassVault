import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_cubit.dart';

@lazySingleton
class GetThemeUseCase {
  final SettingsRepository _repository;

  GetThemeUseCase(this._repository);

  Result<ThemeType> call() {
    return _repository.getTheme();
  }
}
