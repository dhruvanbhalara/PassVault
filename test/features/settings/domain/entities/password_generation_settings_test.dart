import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

void main() {
  group('$PasswordGenerationSettings', () {
    test('creates with default values', () {
      const settings = PasswordGenerationSettings(
        strategies: [],
        defaultStrategyId: '',
      );

      expect(settings.strategies, isEmpty);
      expect(settings.defaultStrategyId, isEmpty);
    });

    test('creates with custom values', () {
      final strategy = PasswordGenerationStrategy.create(name: 'Test');
      final settings = PasswordGenerationSettings(
        strategies: [strategy],
        defaultStrategyId: strategy.id,
      );

      expect(settings.strategies, contains(strategy));
      expect(settings.defaultStrategyId, equals(strategy.id));
    });

    test('defaultStrategy returns correct strategy', () {
      final strategy1 = PasswordGenerationStrategy.create(name: 's1');
      final strategy2 = PasswordGenerationStrategy.create(name: 's2');
      final settings = PasswordGenerationSettings(
        strategies: [strategy1, strategy2],
        defaultStrategyId: strategy2.id,
      );

      expect(settings.defaultStrategy, equals(strategy2));
    });

    test('initial factory creates default strategy', () {
      final settings = PasswordGenerationSettings.initial();
      expect(settings.strategies, isNotEmpty);
      expect(settings.defaultStrategy.length, 16);
    });

    group('copyWith', () {
      test('copies with new strategies', () {
        final strategy1 = PasswordGenerationStrategy.create(name: 's1');
        final strategy2 = PasswordGenerationStrategy.create(name: 's2');
        final settings = PasswordGenerationSettings(
          strategies: [strategy1],
          defaultStrategyId: strategy1.id,
        );

        final copied = settings.copyWith(strategies: [strategy1, strategy2]);

        expect(copied.strategies, hasLength(2));
        expect(copied.defaultStrategyId, equals(strategy1.id));
      });

      test('copies with new defaultStrategyId', () {
        final strategy1 = PasswordGenerationStrategy.create(name: 's1');
        final settings = PasswordGenerationSettings(
          strategies: [strategy1],
          defaultStrategyId: 'old',
        );

        final copied = settings.copyWith(defaultStrategyId: strategy1.id);

        expect(copied.defaultStrategyId, equals(strategy1.id));
        expect(copied.strategies, equals(settings.strategies));
      });
    });

    group('JSON serialization', () {
      test('toJson converts to map correctly', () {
        final strategy = PasswordGenerationStrategy.create(name: 'Test');
        final settings = PasswordGenerationSettings(
          strategies: [strategy],
          defaultStrategyId: strategy.id,
        );

        final json = settings.toJson();

        expect(json['defaultStrategyId'], equals(strategy.id));
        expect((json['strategies'] as List).length, equals(1));
      });

      test('fromJson creates settings from map', () {
        final strategy = PasswordGenerationStrategy.create(name: 'Test');
        final json = {
          'strategies': [strategy.toJson()],
          'defaultStrategyId': strategy.id,
        };

        final settings = PasswordGenerationSettings.fromJson(json);

        expect(settings.defaultStrategyId, equals(strategy.id));
        expect(settings.strategies.length, equals(1));
        expect(settings.strategies.first.id, equals(strategy.id));
      });

      test('fromJson uses defaults for missing keys', () {
        final json = <String, dynamic>{};
        final settings = PasswordGenerationSettings.fromJson(json);

        expect(settings.strategies, isNotEmpty);
        expect(settings.defaultStrategyId, isNotEmpty);
      });

      test(
        'fromJson handles untyped List and Maps correctly (Hive generic output)',
        () {
          final strategy = PasswordGenerationStrategy.create(name: 'Test');
          final json = <String, dynamic>{
            'strategies': <dynamic>[
              // Simulating Map<dynamic, dynamic> which happens with Hive
              <dynamic, dynamic>{...strategy.toJson()},
            ],
            'defaultStrategyId': strategy.id,
          };

          final settings = PasswordGenerationSettings.fromJson(json);
          expect(settings.strategies, isNotEmpty);
          expect(settings.strategies.first.id, equals(strategy.id));
          expect(settings.defaultStrategyId, equals(strategy.id));
        },
      );
    });

    group('equality', () {
      test('equal settings are equal', () {
        final strategy = PasswordGenerationStrategy.create(name: 'Test');
        final settings1 = PasswordGenerationSettings(
          strategies: [strategy],
          defaultStrategyId: strategy.id,
        );
        final settings2 = PasswordGenerationSettings(
          strategies: [strategy],
          defaultStrategyId: strategy.id,
        );

        expect(settings1, equals(settings2));
        expect(settings1.hashCode, equals(settings2.hashCode));
      });
    });
  });
}
