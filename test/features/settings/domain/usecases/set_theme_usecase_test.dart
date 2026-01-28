import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';
import 'package:passvault/features/settings/domain/usecases/set_theme_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockRepository;
  late SetThemeUseCase useCase;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = SetThemeUseCase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(ThemeType.system);
  });

  group('$SetThemeUseCase', () {
    test('should call repository.saveTheme', () async {
      when(
        () => mockRepository.saveTheme(any()),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(ThemeType.dark);

      expect(result, const Success<void>(null));
      verify(() => mockRepository.saveTheme(ThemeType.dark)).called(1);
    });
  });
}
