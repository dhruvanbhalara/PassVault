import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/password_manager/data/services/password_engine_service_impl.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:password_engine/password_engine.dart' hide PasswordFeedback;

void main() {
  late PasswordEngineServiceImpl service;

  setUp(() {
    service = PasswordEngineServiceImpl();
  });

  group('$PasswordEngineServiceImpl', () {
    test('generates password with requested length', () {
      const strategy = PasswordGenerationStrategy(
        id: 'test',
        name: 'Test',
        length: 20,
      );
      final password = service.generatePassword(strategy: strategy);

      expect(password.length, 20);
    });

    test('generates uppercase only password', () {
      const strategy = PasswordGenerationStrategy(
        id: 'test',
        name: 'Test',
        length: 16,
        useNumbers: false,
        useSpecialChars: false,
        useUppercase: true,
        useLowercase: false,
      );
      final password = service.generatePassword(strategy: strategy);

      expect(password, matches(RegExp(r'^[A-Z]+$')));
    });

    test('excludes ambiguous characters when configured', () {
      for (var i = 0; i < 10; i++) {
        const strategy = PasswordGenerationStrategy(
          id: 'test',
          name: 'Test',
          length: 50,
          excludeAmbiguousChars: true,
        );
        final password = service.generatePassword(strategy: strategy);
        expect(password.contains('I'), isFalse);
        expect(password.contains('l'), isFalse);
        expect(password.contains('1'), isFalse);
        expect(password.contains('O'), isFalse);
        expect(password.contains('0'), isFalse);
      }
    });

    test('maps empty password strength to veryWeak', () {
      final feedback = service.estimateStrength('');
      expect(feedback.strength, PasswordStrength.veryWeak);
    });

    test('maps very strong password into expected range', () {
      final feedback = service.estimateStrength('xK9#mL2@pQ7!nR4\$vB6&cY8*');
      expect(
        feedback.strength,
        anyOf(PasswordStrength.strong, PasswordStrength.veryStrong),
      );
    });
  });
}
