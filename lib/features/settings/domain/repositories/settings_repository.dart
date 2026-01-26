import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';

/// Repository for managing application settings.
abstract class SettingsRepository {
  /// Retrieves the current theme type.
  Result<ThemeType> getTheme();

  /// Saves the selected theme type.
  Future<Result<void>> saveTheme(ThemeType theme);

  /// Retrieves whether biometrics are enabled.
  Result<bool> getBiometricsEnabled();

  /// Sets whether biometrics are enabled.
  Future<Result<void>> setBiometricsEnabled(bool enabled);

  /// Retrieves whether onboarding is complete.
  Result<bool> getOnboardingComplete();

  /// Sets onboarding as complete.
  Future<Result<void>> setOnboardingComplete(bool complete);

  /// Retrieves password generation settings.
  Result<PasswordGenerationSettings> getPasswordGenerationSettings();

  /// Saves password generation settings.
  Future<Result<void>> savePasswordGenerationSettings(
    PasswordGenerationSettings settings,
  );
}
