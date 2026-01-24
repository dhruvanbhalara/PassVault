import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/core/services/database_service.dart';
import 'package:passvault/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_cubit.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late MockDatabaseService mockDatabaseService;
  late SettingsRepositoryImpl repository;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    repository = SettingsRepositoryImpl(mockDatabaseService);
  });

  group('getTheme', () {
    test('should return theme from database', () {
      when(
        () => mockDatabaseService.read(
          any(),
          any(),
          defaultValue: any(named: 'defaultValue'),
        ),
      ).thenReturn(ThemeType.dark.index);

      final result = repository.getTheme();

      expect(result, const Success(ThemeType.dark));
      verify(
        () => mockDatabaseService.read(
          'settings',
          'theme_type',
          defaultValue: ThemeType.system.index,
        ),
      ).called(1);
    });

    test('should return Error when database throws', () {
      when(
        () => mockDatabaseService.read(
          any(),
          any(),
          defaultValue: any(named: 'defaultValue'),
        ),
      ).thenThrow(Exception());

      final result = repository.getTheme();

      expect(result, isA<Error>());
    });
  });

  group('saveTheme', () {
    test('should save theme to database', () async {
      when(
        () => mockDatabaseService.write(any(), any(), any()),
      ).thenAnswer((_) async {});

      final result = await repository.saveTheme(ThemeType.dark);

      expect(result, const Success<void>(null));
      verify(
        () => mockDatabaseService.write(
          'settings',
          'theme_type',
          ThemeType.dark.index,
        ),
      ).called(1);
    });
  });

  group('Biometrics', () {
    test('getBiometricsEnabled should return value', () {
      when(
        () => mockDatabaseService.read(
          any(),
          any(),
          defaultValue: any(named: 'defaultValue'),
        ),
      ).thenReturn(true);

      final result = repository.getBiometricsEnabled();

      expect(result, const Success(true));
    });

    test('setBiometricsEnabled should save value', () async {
      when(
        () => mockDatabaseService.write(any(), any(), any()),
      ).thenAnswer((_) async {});

      final result = await repository.setBiometricsEnabled(true);

      expect(result, const Success<void>(null));
    });
  });

  group('Onboarding', () {
    test('getOnboardingComplete should return value', () {
      when(
        () => mockDatabaseService.read(
          any(),
          any(),
          defaultValue: any(named: 'defaultValue'),
        ),
      ).thenReturn(true);

      final result = repository.getOnboardingComplete();

      expect(result, const Success(true));
    });

    test('setOnboardingComplete should save value', () async {
      when(
        () => mockDatabaseService.write(any(), any(), any()),
      ).thenAnswer((_) async {});

      final result = await repository.setOnboardingComplete(true);

      expect(result, const Success<void>(null));
    });
  });

  group('PasswordGenerationSettings', () {
    final tSettings = const PasswordGenerationSettings(
      length: 12,
      useNumbers: true,
    );

    test('getPasswordGenerationSettings should return value', () {
      when(
        () => mockDatabaseService.read(
          any(),
          any(),
          defaultValue: any(named: 'defaultValue'),
        ),
      ).thenReturn(tSettings.toJson());

      final result = repository.getPasswordGenerationSettings();

      expect(result, Success(tSettings));
    });

    test('savePasswordGenerationSettings should save value', () async {
      when(
        () => mockDatabaseService.write(any(), any(), any()),
      ).thenAnswer((_) async {});

      final result = await repository.savePasswordGenerationSettings(tSettings);

      expect(result, const Success<void>(null));
    });
  });
}
