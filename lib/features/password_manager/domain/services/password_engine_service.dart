import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

abstract class PasswordEngineService {
  String generatePassword({required PasswordGenerationStrategy strategy});

  PasswordFeedback estimateStrength(String password);
}
