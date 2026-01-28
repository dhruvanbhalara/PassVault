import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';
import 'package:passvault/features/settings/domain/usecases/onboarding_usecases.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockRepository;
  late GetOnboardingCompleteUseCase getUseCase;
  late SetOnboardingCompleteUseCase setUseCase;

  setUp(() {
    mockRepository = MockSettingsRepository();
    getUseCase = GetOnboardingCompleteUseCase(mockRepository);
    setUseCase = SetOnboardingCompleteUseCase(mockRepository);
  });

  group('$GetOnboardingCompleteUseCase', () {
    test('GetOnboardingCompleteUseCase should call repository', () {
      when(
        () => mockRepository.getOnboardingComplete(),
      ).thenReturn(const Success(true));

      final result = getUseCase();

      expect(result, const Success(true));
      verify(() => mockRepository.getOnboardingComplete()).called(1);
    });
  });

  group('$SetOnboardingCompleteUseCase', () {
    test('SetOnboardingCompleteUseCase should call repository', () async {
      when(
        () => mockRepository.setOnboardingComplete(any()),
      ).thenAnswer((_) async => const Success(null));

      final result = await setUseCase(true);

      expect(result, const Success<void>(null));
      verify(() => mockRepository.setOnboardingComplete(true)).called(1);
    });
  });
}
