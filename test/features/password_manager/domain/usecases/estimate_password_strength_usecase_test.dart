import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';
import 'package:passvault/features/password_manager/domain/services/password_engine_service.dart';
import 'package:passvault/features/password_manager/domain/usecases/estimate_password_strength_usecase.dart';
import 'package:password_engine/password_engine.dart' hide PasswordFeedback;

class _MockPasswordEngineService extends Mock
    implements PasswordEngineService {}

void main() {
  late EstimatePasswordStrengthUseCase useCase;
  late PasswordEngineService service;

  setUp(() {
    service = _MockPasswordEngineService();
    useCase = EstimatePasswordStrengthUseCase(service);
  });

  group('$EstimatePasswordStrengthUseCase', () {
    test('delegates to password engine service', () {
      const feedback = PasswordFeedback(strength: PasswordStrength.strong);
      when(() => service.estimateStrength('Password1!')).thenReturn(feedback);

      final result = useCase('Password1!');

      expect(result, feedback);
      verify(() => service.estimateStrength('Password1!')).called(1);
    });

    test('returns empty feedback when service returns empty feedback', () {
      const feedback = PasswordFeedback.empty();
      when(() => service.estimateStrength('')).thenReturn(feedback);

      final result = useCase('');

      expect(result, feedback);
      verify(() => service.estimateStrength('')).called(1);
    });
  });
}
