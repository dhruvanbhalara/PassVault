import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/password_manager/domain/usecases/estimate_password_strength_usecase.dart';

void main() {
  late EstimatePasswordStrengthUseCase useCase;

  setUp(() {
    useCase = EstimatePasswordStrengthUseCase();
  });

  group('EstimatePasswordStrengthUseCase', () {
    test('returns 0.0 for empty password', () {
      final strength = useCase('');
      expect(strength, equals(0.0));
    });

    test('returns low strength for very weak password', () {
      final strength = useCase('abc');
      expect(strength, lessThanOrEqualTo(0.4));
    });

    test('returns low strength for short numeric password', () {
      final strength = useCase('12345');
      expect(strength, lessThanOrEqualTo(0.4));
    });

    test('returns medium strength for moderate password', () {
      final strength = useCase('Password1');
      expect(strength, greaterThanOrEqualTo(0.4));
      expect(strength, lessThanOrEqualTo(0.8));
    });

    test('returns high strength for strong password', () {
      final strength = useCase('P@ssw0rd!2024Secure');
      expect(strength, greaterThanOrEqualTo(0.6));
    });

    test('returns maximum strength for very strong password', () {
      final strength = useCase('xK9#mL2@pQ7!nR4\$vB6&cY8*');
      expect(strength, greaterThanOrEqualTo(0.8));
    });

    test('returns value between 0.0 and 1.0', () {
      final testPasswords = [
        'a',
        'abc',
        'password',
        'Password1',
        'P@ssw0rd!',
        'VeryLongAndComplexPassword123!@#',
      ];

      for (final password in testPasswords) {
        final strength = useCase(password);
        expect(strength, greaterThanOrEqualTo(0.0));
        expect(strength, lessThanOrEqualTo(1.0));
      }
    });

    test('longer passwords generally have higher strength', () {
      final shortStrength = useCase('Ab1!');
      final longStrength = useCase('Ab1!Ab1!Ab1!Ab1!');
      expect(longStrength, greaterThanOrEqualTo(shortStrength));
    });

    test('passwords with more character variety have higher strength', () {
      final lowVariety = useCase('aaaaaaaaaa');
      final highVariety = useCase('aA1!bB2@cC');
      expect(highVariety, greaterThan(lowVariety));
    });
  });
}
