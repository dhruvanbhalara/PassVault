import 'package:equatable/equatable.dart';
import 'package:password_engine/password_engine.dart'; // Using library enums is usually fine if they are pure Dart

/// Detailed feedback about a password's security.
class PasswordFeedback extends Equatable {
  final PasswordStrength strength;
  final String? warning;
  final List<String> suggestions;
  final double? entropy;
  final int? score;

  const PasswordFeedback({
    required this.strength,
    this.warning,
    this.suggestions = const [],
    this.entropy,
    this.score,
  });

  const PasswordFeedback.empty()
    : strength = PasswordStrength.veryWeak,
      warning = null,
      suggestions = const [],
      entropy = 0,
      score = 0;

  @override
  List<Object?> get props => [strength, warning, suggestions, entropy, score];
}
