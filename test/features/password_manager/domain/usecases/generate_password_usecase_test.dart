import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';

void main() {
  late GeneratePasswordUseCase useCase;

  setUp(() {
    useCase = GeneratePasswordUseCase();
  });

  group('$GeneratePasswordUseCase', () {
    test('generates password with default length of 12', () {
      final password = useCase();
      expect(password.length, equals(12));
    });

    test('generates password with custom length', () {
      final password = useCase(length: 20);
      expect(password.length, equals(20));
    });

    test('generates password with minimum length of 12', () {
      final password = useCase(length: 12);
      expect(password.length, equals(12));
    });

    test('generates password with maximum length of 64', () {
      final password = useCase(length: 64);
      expect(password.length, equals(64));
    });

    test('generates password with uppercase letters only', () {
      final password = useCase(
        useUppercase: true,
        useLowercase: false,
        useNumbers: false,
        useSpecialChars: false,
      );
      expect(password, matches(RegExp(r'^[A-Z]+$')));
    });

    test('generates password with lowercase letters only', () {
      final password = useCase(
        useUppercase: false,
        useLowercase: true,
        useNumbers: false,
        useSpecialChars: false,
      );
      expect(password, matches(RegExp(r'^[a-z]+$')));
    });

    test('generates password with numbers only', () {
      final password = useCase(
        useUppercase: false,
        useLowercase: false,
        useNumbers: true,
        useSpecialChars: false,
      );
      expect(password, matches(RegExp(r'^[0-9]+$')));
    });

    test('generates password with special characters only', () {
      final password = useCase(
        useUppercase: false,
        useLowercase: false,
        useNumbers: false,
        useSpecialChars: true,
      );
      // Special chars pattern
      expect(password.isNotEmpty, isTrue);
      expect(
        password.split('').every((c) => !RegExp(r'[a-zA-Z0-9]').hasMatch(c)),
        isTrue,
      );
    });

    test('generates password with all character sets', () {
      final password = useCase(
        length: 32,
        useUppercase: true,
        useLowercase: true,
        useNumbers: true,
        useSpecialChars: true,
      );
      expect(password.length, equals(32));
    });

    test('excludes ambiguous characters when flag is set', () {
      // Generate multiple passwords to increase confidence
      for (var i = 0; i < 10; i++) {
        final password = useCase(
          length: 50,
          useUppercase: true,
          useLowercase: true,
          useNumbers: true,
          useSpecialChars: false,
          excludeAmbiguousChars: true,
        );
        // Ambiguous: I, l, 1, O, 0
        expect(password.contains('I'), isFalse);
        expect(password.contains('l'), isFalse);
        expect(password.contains('1'), isFalse);
        expect(password.contains('O'), isFalse);
        expect(password.contains('0'), isFalse);
      }
    });

    test('generates unique passwords on each call', () {
      final passwords = <String>{};
      for (var i = 0; i < 100; i++) {
        passwords.add(useCase(length: 16));
      }
      // All passwords should be unique
      expect(passwords.length, equals(100));
    });
  });
}
