import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';
import 'package:passvault/features/password_manager/domain/services/password_engine_service.dart';

/// Use case for estimating password strength using the password_engine library.
@lazySingleton
class EstimatePasswordStrengthUseCase {
  final PasswordEngineService _passwordEngineService;

  EstimatePasswordStrengthUseCase(this._passwordEngineService);

  /// Estimates the strength of a password.
  PasswordFeedback call(String password) {
    return _passwordEngineService.estimateStrength(password);
  }
}
