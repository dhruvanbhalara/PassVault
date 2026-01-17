import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';
import 'package:passvault/features/settings/domain/usecases/get_theme_usecase.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_cubit.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockRepository;
  late GetThemeUseCase useCase;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = GetThemeUseCase(mockRepository);
  });

  test('should call repository.getTheme', () {
    when(
      () => mockRepository.getTheme(),
    ).thenReturn(const Success(ThemeType.system));

    final result = useCase();

    expect(result, const Success(ThemeType.system));
    verify(() => mockRepository.getTheme()).called(1);
  });
}
