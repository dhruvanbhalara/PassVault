import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/features/password_manager/domain/services/password_engine_service.dart';
import 'package:passvault/features/password_manager/domain/usecases/generate_password_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/entities/password_strategy_type.dart';

class _MockPasswordEngineService extends Mock
    implements PasswordEngineService {}

void main() {
  late GeneratePasswordUseCase useCase;
  late PasswordEngineService service;

  setUpAll(() {
    registerFallbackValue(
      const PasswordGenerationStrategy(id: 'fallback', name: 'fallback'),
    );
  });

  setUp(() {
    service = _MockPasswordEngineService();
    useCase = GeneratePasswordUseCase(service);
  });

  group('$GeneratePasswordUseCase', () {
    test('delegates strategy to password engine service', () {
      final strategy = const PasswordGenerationStrategy(
        id: '1',
        name: 'Default',
        type: PasswordStrategyType.random,
        length: 12,
        useNumbers: true,
        useSpecialChars: true,
        useUppercase: true,
        useLowercase: true,
        excludeAmbiguousChars: false,
      );

      when(
        () => service.generatePassword(strategy: any(named: 'strategy')),
      ).thenReturn('generated-password');

      final result = useCase(strategy: strategy);

      expect(result, 'generated-password');
      verify(() => service.generatePassword(strategy: strategy)).called(1);
    });

    test('delegates memorable strategy to password engine service', () {
      final strategy = const PasswordGenerationStrategy(
        id: '2',
        name: 'Memorable',
        type: PasswordStrategyType.memorable,
        wordCount: 4,
        separator: '-',
      );

      when(
        () => service.generatePassword(strategy: any(named: 'strategy')),
      ).thenReturn('memorable-password');

      final result = useCase(strategy: strategy);

      expect(result, 'memorable-password');
      verify(() => service.generatePassword(strategy: strategy)).called(1);
    });
  });
}
