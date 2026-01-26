import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

void main() {
  group('$PasswordGenerationSettings', () {
    test('creates with default values', () {
      const settings = PasswordGenerationSettings();

      expect(settings.length, equals(16));
      expect(settings.useNumbers, isTrue);
      expect(settings.useSpecialChars, isTrue);
      expect(settings.useUppercase, isTrue);
      expect(settings.useLowercase, isTrue);
      expect(settings.excludeAmbiguousChars, isFalse);
    });

    test('creates with custom values', () {
      const settings = PasswordGenerationSettings(
        length: 24,
        useNumbers: false,
        useSpecialChars: true,
        useUppercase: true,
        useLowercase: false,
        excludeAmbiguousChars: true,
      );

      expect(settings.length, equals(24));
      expect(settings.useNumbers, isFalse);
      expect(settings.useSpecialChars, isTrue);
      expect(settings.useUppercase, isTrue);
      expect(settings.useLowercase, isFalse);
      expect(settings.excludeAmbiguousChars, isTrue);
    });

    group('copyWith', () {
      test('copies with new length', () {
        const settings = PasswordGenerationSettings();
        final copied = settings.copyWith(length: 32);

        expect(copied.length, equals(32));
        expect(copied.useNumbers, equals(settings.useNumbers));
        expect(copied.useSpecialChars, equals(settings.useSpecialChars));
      });

      test('copies with new boolean values', () {
        const settings = PasswordGenerationSettings();
        final copied = settings.copyWith(
          useNumbers: false,
          excludeAmbiguousChars: true,
        );

        expect(copied.useNumbers, isFalse);
        expect(copied.excludeAmbiguousChars, isTrue);
        expect(copied.length, equals(settings.length));
      });

      test('returns identical settings when no parameters passed', () {
        const settings = PasswordGenerationSettings(
          length: 20,
          useNumbers: false,
        );
        final copied = settings.copyWith();

        expect(copied, equals(settings));
      });
    });

    group('JSON serialization', () {
      test('toJson converts to map correctly', () {
        const settings = PasswordGenerationSettings(
          length: 20,
          useNumbers: true,
          useSpecialChars: false,
          useUppercase: true,
          useLowercase: false,
          excludeAmbiguousChars: true,
        );

        final json = settings.toJson();

        expect(json['length'], equals(20));
        expect(json['useNumbers'], isTrue);
        expect(json['useSpecialChars'], isFalse);
        expect(json['useUppercase'], isTrue);
        expect(json['useLowercase'], isFalse);
        expect(json['excludeAmbiguousChars'], isTrue);
      });

      test('fromJson creates settings from map', () {
        final json = {
          'length': 24,
          'useNumbers': false,
          'useSpecialChars': true,
          'useUppercase': false,
          'useLowercase': true,
          'excludeAmbiguousChars': true,
        };

        final settings = PasswordGenerationSettings.fromJson(json);

        expect(settings.length, equals(24));
        expect(settings.useNumbers, isFalse);
        expect(settings.useSpecialChars, isTrue);
        expect(settings.useUppercase, isFalse);
        expect(settings.useLowercase, isTrue);
        expect(settings.excludeAmbiguousChars, isTrue);
      });

      test('fromJson uses defaults for missing keys', () {
        final json = <String, dynamic>{};
        final settings = PasswordGenerationSettings.fromJson(json);

        expect(settings.length, equals(16));
        expect(settings.useNumbers, isTrue);
        expect(settings.useSpecialChars, isTrue);
        expect(settings.useUppercase, isTrue);
        expect(settings.useLowercase, isTrue);
        expect(settings.excludeAmbiguousChars, isFalse);
      });

      test('roundtrip toJson -> fromJson preserves data', () {
        const original = PasswordGenerationSettings(
          length: 28,
          useNumbers: false,
          useSpecialChars: true,
          useUppercase: false,
          useLowercase: true,
          excludeAmbiguousChars: true,
        );

        final json = original.toJson();
        final restored = PasswordGenerationSettings.fromJson(json);

        expect(restored, equals(original));
      });
    });

    group('equality', () {
      test('equal settings are equal', () {
        const settings1 = PasswordGenerationSettings(length: 20);
        const settings2 = PasswordGenerationSettings(length: 20);

        expect(settings1, equals(settings2));
        expect(settings1.hashCode, equals(settings2.hashCode));
      });

      test('different settings are not equal', () {
        const settings1 = PasswordGenerationSettings(length: 20);
        const settings2 = PasswordGenerationSettings(length: 24);

        expect(settings1, isNot(equals(settings2)));
      });
    });
  });
}
