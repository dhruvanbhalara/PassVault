import 'package:injectable/injectable.dart';
import 'package:password_engine/password_engine.dart';

/// Use case for estimating password strength using the password_engine library.
///
/// This use case uses the library's entropy-based strength estimation which
/// automatically analyzes the password's character composition (uppercase,
/// lowercase, numbers, special chars) and calculates strength accordingly.
///
/// The library's algorithm:
///   E = L * log2(N)
/// Where L is password length and N is the character pool size.
@lazySingleton
class EstimatePasswordStrengthUseCase {
  final PasswordStrengthEstimator _strengthEstimator;

  EstimatePasswordStrengthUseCase()
    : _strengthEstimator = PasswordStrengthEstimator();

  /// Estimates the strength of a password.
  ///
  /// Returns a value between 0.0 and 1.0:
  /// - 0.0 = empty password
  /// - 0.2 = very weak (entropy < 40)
  /// - 0.4 = weak (entropy 40-59)
  /// - 0.6 = medium (entropy 60-74)
  /// - 0.8 = strong (entropy 75-127)
  /// - 1.0 = very strong (entropy >= 128)
  double call(String password) {
    if (password.isEmpty) return 0.0;

    final strength = _strengthEstimator.estimatePasswordStrength(password);

    return switch (strength) {
      PasswordStrength.veryWeak => 0.2,
      PasswordStrength.weak => 0.4,
      PasswordStrength.medium => 0.6,
      PasswordStrength.strong => 0.8,
      PasswordStrength.veryStrong => 1.0,
    };
  }

  /// Returns the raw PasswordStrength enum from the library.
  PasswordStrength getStrengthLevel(String password) {
    if (password.isEmpty) return PasswordStrength.veryWeak;
    return _strengthEstimator.estimatePasswordStrength(password);
  }
}
