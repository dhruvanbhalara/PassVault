import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart'
    as domain;
import 'package:passvault/features/password_manager/domain/services/password_engine_service.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/entities/password_strategy_type.dart';
import 'package:password_engine/password_engine.dart';

@LazySingleton(as: PasswordEngineService)
class PasswordEngineServiceImpl implements PasswordEngineService {
  @override
  String generatePassword({required PasswordGenerationStrategy strategy}) {
    final IPasswordGenerationStrategy engineStrategy;

    if (strategy.type == PasswordStrategyType.memorable) {
      // Using a basic wordlist for integration phase, expandable by user later
      final wordlist = [
        'correct',
        'horse',
        'battery',
        'staple',
        'mountain',
        'river',
        'ocean',
        'cloud',
        'forest',
        'desert',
        'bridge',
        'castle',
        'garden',
        'island',
        'valley',
        'stone',
        'water',
        'flame',
        'earth',
        'light',
        'dark',
        'night',
        'day',
        'wind',
        'rain',
        'snow',
        'storm',
        'green',
        'blue',
        'red',
        'gold',
        'silver',
        'space',
        'star',
        'moon',
        'sun',
        'planet',
        'comet',
        'world',
        'bread',
        'apple',
        'coffee',
        'train',
        'plane',
        'truck',
        'bike',
        'house',
        'street',
        'road',
        'city',
        'town',
        'music',
        'book',
        'paper',
        'pen',
        'key',
        'door',
        'lamp',
        'phone',
        'clock',
        'watch',
        'heart',
        'mind',
        'soul',
      ];

      engineStrategy = PassphrasePasswordStrategy(
        wordlist: wordlist,
        separator: strategy.separator,
      );
    } else {
      engineStrategy = RandomPasswordStrategy();
    }

    final config = PasswordGeneratorConfig.builder()
        .length(
          strategy.type == PasswordStrategyType.memorable
              ? strategy.wordCount
              : strategy.length,
        )
        .useNumbers(strategy.useNumbers)
        .useSpecialChars(strategy.useSpecialChars)
        .useUpperCase(strategy.useUppercase)
        .useLowerCase(strategy.useLowercase)
        .excludeAmbiguousChars(strategy.excludeAmbiguousChars)
        .build();

    final generator = PasswordGenerator(generationStrategy: engineStrategy);
    generator.updateConfig(config);
    return generator.generatePassword();
  }

  @override
  domain.PasswordFeedback estimateStrength(String password) {
    if (password.isEmpty) {
      return const domain.PasswordFeedback(strength: PasswordStrength.veryWeak);
    }

    final generator = PasswordGenerator();
    final feedback = generator.estimateFeedback(password);

    return domain.PasswordFeedback(
      strength: feedback.strength,
      warning: feedback.warning,
      suggestions: feedback.suggestions,
      entropy: feedback.estimatedEntropy,
      score: feedback.score,
    );
  }
}
