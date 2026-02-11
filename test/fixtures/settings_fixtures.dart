import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

class SettingsFixtures {
  static const defaultStrategy = PasswordGenerationStrategy(
    id: 'default-strategy',
    name: 'Default',
    length: 16,
  );

  static const secureStrategy = PasswordGenerationStrategy(
    id: 'secure-strategy',
    name: 'Secure',
    length: 32,
    useSpecialChars: true,
    excludeAmbiguousChars: true,
  );

  static final initialSettings = PasswordGenerationSettings(
    strategies: [defaultStrategy],
    defaultStrategyId: defaultStrategy.id,
  );

  static final advancedSettings = PasswordGenerationSettings(
    strategies: [defaultStrategy, secureStrategy],
    defaultStrategyId: secureStrategy.id,
  );
}
