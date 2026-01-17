import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';
import 'package:passvault/features/settings/domain/usecases/password_settings_usecases.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockRepository;
  late GetPasswordGenerationSettingsUseCase getUseCase;
  late SavePasswordGenerationSettingsUseCase saveUseCase;

  setUp(() {
    mockRepository = MockSettingsRepository();
    getUseCase = GetPasswordGenerationSettingsUseCase(mockRepository);
    saveUseCase = SavePasswordGenerationSettingsUseCase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(const PasswordGenerationSettings());
  });

  final tSettings = PasswordGenerationSettings();

  test('GetPasswordGenerationSettingsUseCase should call repository', () {
    when(
      () => mockRepository.getPasswordGenerationSettings(),
    ).thenReturn(Success(tSettings));

    final result = getUseCase();

    expect(result, Success(tSettings));
    verify(() => mockRepository.getPasswordGenerationSettings()).called(1);
  });

  test(
    'SavePasswordGenerationSettingsUseCase should call repository',
    () async {
      when(
        () => mockRepository.savePasswordGenerationSettings(any()),
      ).thenAnswer((_) async => const Success(null));

      final result = await saveUseCase(tSettings);

      expect(result, const Success<void>(null));
      verify(
        () => mockRepository.savePasswordGenerationSettings(tSettings),
      ).called(1);
    },
  );
}
