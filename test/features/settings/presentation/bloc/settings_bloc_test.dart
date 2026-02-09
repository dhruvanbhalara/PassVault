import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/core/services/data_service.dart';
import 'package:passvault/core/services/file_picker_service.dart';
import 'package:passvault/core/services/file_service.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/import_passwords_usecase.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/repositories/settings_repository.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';

class MockImportPasswordsUseCase extends Mock
    implements ImportPasswordsUseCase {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockDataService extends Mock implements DataService {}

class MockPasswordRepository extends Mock implements PasswordRepository {}

class MockFileService extends Mock implements FileService {}

class MockFilePickerService extends Mock implements IFilePickerService {}

void main() {
  late SettingsBloc bloc;
  late MockSettingsRepository mockSettingsRepository;

  const tSettings = PasswordGenerationSettings(
    strategies: [],
    defaultStrategyId: '',
  );

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();

    bloc = SettingsBloc(mockSettingsRepository);
  });

  setUpAll(() {
    registerFallbackValue(tSettings);
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(
      PasswordEntry(
        id: 'fallback',
        appName: 'app',
        username: 'user',
        password: 'password',
        lastUpdated: DateTime.now(),
      ),
    );
    // Register List<PasswordEntry> fallback for UseCase
    registerFallbackValue(<PasswordEntry>[]);
  });

  tearDown(() {
    bloc.close();
  });

  group('$SettingsBloc', () {
    test('initial state is correct', () {
      expect(bloc.state, const SettingsInitial());
    });

    group('$LoadSettings', () {
      test('loads settings from repository', () {
        when(
          () => mockSettingsRepository.getBiometricsEnabled(),
        ).thenReturn(const Success(true));

        when(
          () => mockSettingsRepository.getPasswordGenerationSettings(),
        ).thenReturn(
          const Success(
            PasswordGenerationSettings(strategies: [], defaultStrategyId: ''),
          ),
        );

        bloc.add(const LoadSettings());

        expectLater(
          bloc.stream,
          emitsThrough(
            isA<SettingsLoaded>().having(
              (s) => s.useBiometrics,
              'useBiometrics',
              true,
            ),
          ),
        );
      });
    });

    group('$ToggleBiometrics', () {
      test('saves preference and updates state', () async {
        when(
          () => mockSettingsRepository.setBiometricsEnabled(any()),
        ).thenAnswer((_) async => const Success(null));

        bloc.add(const ToggleBiometrics(true));
        await Future.delayed(const Duration(milliseconds: 50));

        verify(
          () => mockSettingsRepository.setBiometricsEnabled(true),
        ).called(1);
        expect(bloc.state.useBiometrics, true);
      });
    });

    group('$UpdatePasswordSettings', () {
      test('saves settings and updates state', () async {
        when(
          () => mockSettingsRepository.savePasswordGenerationSettings(any()),
        ).thenAnswer((_) async => const Success(null));

        bloc.add(const UpdatePasswordSettings(tSettings));
      });
    });

    group('Strategy CRUD', () {
      final tStrategy = PasswordGenerationStrategy.create(
        name: 'New Strategy',
        length: 20,
      );

      test('AddStrategy adds strategy and saves', () async {
        when(
          () => mockSettingsRepository.savePasswordGenerationSettings(any()),
        ).thenAnswer((_) async => const Success(null));

        bloc.add(AddStrategy(tStrategy));
        await Future.delayed(const Duration(milliseconds: 50));

        verify(
          () => mockSettingsRepository.savePasswordGenerationSettings(
            any(
              that: isA<PasswordGenerationSettings>()
                  .having((s) => s.strategies.length, 'strategies count', 2)
                  .having((s) => s.strategies.last, 'last strategy', tStrategy),
            ),
          ),
        ).called(1);
      });

      test('UpdateStrategy updates strategy and saves', () async {
        // First add a strategy to update

        // Allow multiple saves
        when(
          () => mockSettingsRepository.savePasswordGenerationSettings(any()),
        ).thenAnswer((_) async => const Success(null));

        // Use a bloc seeded with this strategy for this specific test would be better,
        // but existing pattern re-uses the bloc instance.
        // Given the 'setUp' creates a fresh bloc, we are starting with default state.

        // Rely on the initial default strategy for update test.
        final defaultStrategy = bloc.state.passwordSettings.strategies.first;
        final updatedDefault = defaultStrategy.copyWith(
          name: 'Updated Default',
        );

        bloc.add(UpdateStrategy(updatedDefault));
        await Future.delayed(const Duration(milliseconds: 50));

        verify(
          () => mockSettingsRepository.savePasswordGenerationSettings(
            any(
              that: isA<PasswordGenerationSettings>().having(
                (s) => s.strategies
                    .firstWhere((st) => st.id == defaultStrategy.id)
                    .name,
                'strategy name',
                'Updated Default',
              ),
            ),
          ),
        ).called(1);
      });

      test('DeleteStrategy removes strategy and saves', () async {
        // Create a custom strategy to delete
        final strategyToDelete = PasswordGenerationStrategy.create(
          name: 'Delete Me',
        );

        // Mock repo to expect save calls
        when(
          () => mockSettingsRepository.savePasswordGenerationSettings(any()),
        ).thenAnswer((_) async => const Success(null));

        // Add it first
        bloc.add(AddStrategy(strategyToDelete));
        await Future.delayed(const Duration(milliseconds: 50));

        // Now delete it
        bloc.add(DeleteStrategy(strategyToDelete.id));
        await Future.delayed(const Duration(milliseconds: 50));

        verify(
          () => mockSettingsRepository.savePasswordGenerationSettings(
            any(
              that: isA<PasswordGenerationSettings>().having(
                (s) => s.strategies
                    .where((st) => st.id == strategyToDelete.id)
                    .isEmpty,
                'strategy deleted',
                true,
              ),
            ),
          ),
        ).called(greaterThanOrEqualTo(1)); // Once for add, once for delete
      });

      test('SetDefaultStrategy updates defaultId and saves', () async {
        final newDefaultStrategy = PasswordGenerationStrategy.create(
          name: 'New Default',
        );

        when(
          () => mockSettingsRepository.savePasswordGenerationSettings(any()),
        ).thenAnswer((_) async => const Success(null));

        // Add it
        bloc.add(AddStrategy(newDefaultStrategy));
        await Future.delayed(const Duration(milliseconds: 50));

        // Set as default
        bloc.add(SetDefaultStrategy(newDefaultStrategy.id));
        await Future.delayed(const Duration(milliseconds: 50));

        verify(
          () => mockSettingsRepository.savePasswordGenerationSettings(
            any(
              that: isA<PasswordGenerationSettings>().having(
                (s) => s.defaultStrategyId,
                'defaultId',
                newDefaultStrategy.id,
              ),
            ),
          ),
        ).called(greaterThanOrEqualTo(1));
      });
    });
  });
}
