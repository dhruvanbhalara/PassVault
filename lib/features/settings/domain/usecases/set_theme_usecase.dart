import 'package:injectable/injectable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_cubit.dart';

@lazySingleton
class SetThemeUseCase {
  final SettingsRepository _repository;

  SetThemeUseCase(this._repository);

  Future<Result<void>> call(ThemeType theme) async {
    return _repository.saveTheme(theme);
  }
}
