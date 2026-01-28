import 'package:injectable/injectable.dart';
import 'package:passvault/core/constants/storage_keys.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/core/services/database_service.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final DatabaseService _dbService;

  static const String _themeBoxName = 'settings';
  static const String _themeKey = 'theme_type';

  SettingsRepositoryImpl(this._dbService);

  @override
  Result<ThemeType> getTheme() {
    try {
      final themeIndex = _dbService.read(
        _themeBoxName,
        _themeKey,
        defaultValue: ThemeType.system.index,
      );
      final themeType = ThemeType.values[themeIndex];
      return Success(themeType);
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> saveTheme(ThemeType theme) async {
    try {
      await _dbService.write(_themeBoxName, _themeKey, theme.index);
      return const Success(null);
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  @override
  Result<bool> getBiometricsEnabled() {
    try {
      final enabled = _dbService.read(
        StorageKeys.settingsBox,
        StorageKeys.useBiometrics,
        defaultValue: false,
      );
      return Success(enabled);
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> setBiometricsEnabled(bool enabled) async {
    try {
      await _dbService.write(
        StorageKeys.settingsBox,
        StorageKeys.useBiometrics,
        enabled,
      );
      return const Success(null);
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  @override
  Result<bool> getOnboardingComplete() {
    try {
      final complete = _dbService.read(
        StorageKeys.settingsBox,
        StorageKeys.onboardingComplete,
        defaultValue: false,
      );
      return Success(complete);
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> setOnboardingComplete(bool complete) async {
    try {
      await _dbService.write(
        StorageKeys.settingsBox,
        StorageKeys.onboardingComplete,
        complete,
      );
      return const Success(null);
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }

  @override
  Result<PasswordGenerationSettings> getPasswordGenerationSettings() {
    try {
      final json = _dbService.read(
        StorageKeys.settingsBox,
        StorageKeys.passwordSettings,
        defaultValue: null,
      );

      final settings = json != null
          ? PasswordGenerationSettings.fromJson(Map<String, dynamic>.from(json))
          : const PasswordGenerationSettings();

      return Success(settings);
    } catch (e) {
      // In case of parsing error, return default settings
      return const Success(PasswordGenerationSettings());
    }
  }

  @override
  Future<Result<void>> savePasswordGenerationSettings(
    PasswordGenerationSettings settings,
  ) async {
    try {
      await _dbService.write(
        StorageKeys.settingsBox,
        StorageKeys.passwordSettings,
        settings.toJson(),
      );
      return const Success(null);
    } catch (e) {
      return const Error(UnknownFailure());
    }
  }
}
