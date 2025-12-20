import 'package:injectable/injectable.dart';
import 'package:password_engine/password_engine.dart';

@lazySingleton
class GeneratePasswordUseCase {
  final PasswordGenerator _generator;

  GeneratePasswordUseCase() : _generator = PasswordGenerator();

  String call({
    int length = 12,
    bool useNumbers = true,
    bool useSpecialChars = true,
    bool useUppercase = true,
    bool useLowercase = true,
    bool excludeAmbiguousChars = false,
  }) {
    return _generator.generatePassword(
      length: length,
      useNumbers: useNumbers,
      useSpecialChars: useSpecialChars,
      useUpperCase: useUppercase,
      useLowerCase: useLowercase,
      excludeAmbiguousChars: excludeAmbiguousChars,
    );
  }
}
