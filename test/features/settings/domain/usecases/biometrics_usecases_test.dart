import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';
import 'package:passvault/features/settings/domain/usecases/biometrics_usecases.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockRepository;
  late GetBiometricsEnabledUseCase getUseCase;
  late SetBiometricsEnabledUseCase setUseCase;

  setUp(() {
    mockRepository = MockSettingsRepository();
    getUseCase = GetBiometricsEnabledUseCase(mockRepository);
    setUseCase = SetBiometricsEnabledUseCase(mockRepository);
  });

  test('GetBiometricsEnabledUseCase should call repository', () {
    when(
      () => mockRepository.getBiometricsEnabled(),
    ).thenReturn(const Success(true));

    final result = getUseCase();

    expect(result, const Success(true));
    verify(() => mockRepository.getBiometricsEnabled()).called(1);
  });

  test('SetBiometricsEnabledUseCase should call repository', () async {
    when(
      () => mockRepository.setBiometricsEnabled(any()),
    ).thenAnswer((_) async => const Success(null));

    final result = await setUseCase(true);

    expect(result, const Success<void>(null));
    verify(() => mockRepository.setBiometricsEnabled(true)).called(1);
  });
}
