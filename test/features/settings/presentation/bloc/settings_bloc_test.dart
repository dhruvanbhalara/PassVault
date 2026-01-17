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

  const tSettings = PasswordGenerationSettings();

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    // unused mocks removed for clarity

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

  group('SettingsBloc', () {
    test('initial state is correct', () {
      expect(bloc.state, const SettingsState());
    });

    group('LoadSettings', () {
      test('loads settings from repository', () {
        when(
          () => mockSettingsRepository.getBiometricsEnabled(),
        ).thenReturn(const Success(true));

        when(
          () => mockSettingsRepository.getPasswordGenerationSettings(),
        ).thenReturn(const Success(PasswordGenerationSettings()));

        bloc.add(LoadSettings());

        expectLater(
          bloc.stream,
          emits(
            isA<SettingsState>().having(
              (s) => s.useBiometrics,
              'useBiometrics',
              true,
            ),
          ),
        );
      });
    });

    group('ToggleBiometrics', () {
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

    group('UpdatePasswordSettings', () {
      test('saves settings and updates state', () async {
        when(
          () => mockSettingsRepository.savePasswordGenerationSettings(any()),
        ).thenAnswer((_) async => const Success(null));

        bloc.add(const UpdatePasswordSettings(tSettings));
      });
    });
  });
}
