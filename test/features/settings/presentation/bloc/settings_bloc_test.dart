import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/services/data_service.dart';
import 'package:passvault/core/services/database_service.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

class MockDataService extends Mock implements DataService {}

class MockPasswordRepository extends Mock implements PasswordRepository {}

void main() {
  late SettingsBloc bloc;
  late MockDatabaseService mockDatabaseService;
  late MockDataService mockDataService;
  late MockPasswordRepository mockPasswordRepository;

  const tSettings = PasswordGenerationSettings();

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    mockDataService = MockDataService();
    mockPasswordRepository = MockPasswordRepository();

    bloc = SettingsBloc(
      mockDatabaseService,
      mockDataService,
      mockPasswordRepository,
    );
  });

  setUpAll(() {
    registerFallbackValue(tSettings);
    registerFallbackValue(Uint8List(0));
  });

  tearDown(() {
    bloc.close();
  });

  group('SettingsBloc', () {
    test('initial state is correct', () {
      expect(bloc.state, const SettingsState());
    });

    group('LoadSettings', () {
      test('loads settings from database', () {
        when(
          () => mockDatabaseService.read(any(), any(), defaultValue: false),
        ).thenReturn(true);
        when(
          () => mockDatabaseService.read(any(), any(), defaultValue: null),
        ).thenReturn(null);

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
      test('updates database and state', () async {
        when(
          () => mockDatabaseService.write(any(), any(), any()),
        ).thenAnswer((_) async {});

        bloc.add(const ToggleBiometrics(true));

        await expectLater(
          bloc.stream,
          emits(
            isA<SettingsState>().having(
              (s) => s.useBiometrics,
              'useBiometrics',
              true,
            ),
          ),
        );
        verify(() => mockDatabaseService.write(any(), any(), true)).called(1);
      });
    });

    group('UpdatePasswordSettings', () {
      test('updates database and state', () async {
        when(
          () => mockDatabaseService.write(any(), any(), any()),
        ).thenAnswer((_) async {});

        bloc.add(const UpdatePasswordSettings(tSettings));

        await expectLater(
          bloc.stream,
          emits(
            isA<SettingsState>().having(
              (s) => s.passwordSettings,
              'passwordSettings',
              tSettings,
            ),
          ),
        );
        verify(
          () => mockDatabaseService.write(any(), any(), tSettings.toJson()),
        ).called(1);
      });
    });

    group('ExportData', () {
      test('emits success when export succeeds', () async {
        when(() => mockPasswordRepository.getPasswords()).thenAnswer(
          (_) async => [
            PasswordEntry(
              id: '1',
              appName: 'app',
              username: 'user',
              password: 'pass',
              lastUpdated: DateTime.now(),
            ),
          ],
        );
        when(
          () => mockDataService.exportToJson(any()),
        ).thenAnswer((_) async {});

        bloc.add(const ExportData(isJson: true));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<SettingsState>().having(
              (s) => s.status,
              'status',
              SettingsStatus.loading,
            ),
            isA<SettingsState>()
                .having((s) => s.status, 'status', SettingsStatus.success)
                .having(
                  (s) => s.success,
                  'success',
                  SettingsSuccess.exportSuccess,
                ),
          ]),
        );
      });

      test('emits failure when no data to export', () async {
        when(
          () => mockPasswordRepository.getPasswords(),
        ).thenAnswer((_) async => []);

        bloc.add(const ExportData(isJson: true));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<SettingsState>().having(
              (s) => s.status,
              'status',
              SettingsStatus.loading,
            ),
            isA<SettingsState>()
                .having((s) => s.status, 'status', SettingsStatus.failure)
                .having((s) => s.error, 'error', SettingsError.noDataToExport),
          ]),
        );
      });
    });

    group('ExportEncryptedData', () {
      final testPassword = PasswordEntry(
        id: '1',
        appName: 'Test App',
        username: 'testuser',
        password: 'testpass123',
        lastUpdated: DateTime.now(),
      );

      test('emits success when encrypted export succeeds', () async {
        when(
          () => mockPasswordRepository.getPasswords(),
        ).thenAnswer((_) async => [testPassword]);
        when(
          () => mockDataService.exportToEncryptedJson(any(), any()),
        ).thenAnswer((_) async {});

        bloc.add(const ExportEncryptedData(password: 'secretPassword'));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<SettingsState>().having(
              (s) => s.status,
              'status',
              SettingsStatus.loading,
            ),
            isA<SettingsState>()
                .having((s) => s.status, 'status', SettingsStatus.success)
                .having(
                  (s) => s.success,
                  'success',
                  SettingsSuccess.exportSuccess,
                ),
          ]),
        );

        verify(
          () => mockDataService.exportToEncryptedJson(
            any(that: contains(testPassword)),
            'secretPassword',
          ),
        ).called(1);
      });

      test('emits failure when no passwords to export', () async {
        when(
          () => mockPasswordRepository.getPasswords(),
        ).thenAnswer((_) async => []);

        bloc.add(const ExportEncryptedData(password: 'secretPassword'));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<SettingsState>().having(
              (s) => s.status,
              'status',
              SettingsStatus.loading,
            ),
            isA<SettingsState>()
                .having((s) => s.status, 'status', SettingsStatus.failure)
                .having((s) => s.error, 'error', SettingsError.noDataToExport),
          ]),
        );
      });

      test('emits failure when export throws exception', () async {
        when(
          () => mockPasswordRepository.getPasswords(),
        ).thenAnswer((_) async => [testPassword]);
        when(
          () => mockDataService.exportToEncryptedJson(any(), any()),
        ).thenThrow(Exception('Export failed'));

        bloc.add(const ExportEncryptedData(password: 'secretPassword'));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<SettingsState>().having(
              (s) => s.status,
              'status',
              SettingsStatus.loading,
            ),
            isA<SettingsState>()
                .having((s) => s.status, 'status', SettingsStatus.failure)
                .having((s) => s.error, 'error', SettingsError.unknown),
          ]),
        );
      });
    });

    group('ImportEncryptedData', () {
      test('emits initial when filePath is null', () async {
        bloc.add(const ImportEncryptedData(password: 'password'));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<SettingsState>().having(
              (s) => s.status,
              'status',
              SettingsStatus.loading,
            ),
            isA<SettingsState>().having(
              (s) => s.status,
              'status',
              SettingsStatus.initial,
            ),
          ]),
        );
      });

      // Note: Since file read happens before importFromEncrypted,
      // StateError from decryption can only be tested with integration tests.
      // This test documents that file errors result in importFailed.
      test(
        'emits importFailed when file read fails (wrong password scenario)',
        () async {
          // File read will fail for non-existent path, resulting in importFailed
          bloc.add(
            const ImportEncryptedData(
              password: 'wrongPassword',
              filePath: '/path/to/test.pvault',
            ),
          );

          await expectLater(
            bloc.stream,
            emitsInOrder([
              isA<SettingsState>().having(
                (s) => s.status,
                'status',
                SettingsStatus.loading,
              ),
              isA<SettingsState>()
                  .having((s) => s.status, 'status', SettingsStatus.failure)
                  .having((s) => s.error, 'error', SettingsError.importFailed),
            ]),
          );
        },
      );

      test('emits importFailed when general exception occurs', () async {
        when(
          () => mockDataService.importFromEncrypted(any(), any()),
        ).thenThrow(Exception('File read error'));

        bloc.add(
          const ImportEncryptedData(
            password: 'password',
            filePath: '/path/to/test.pvault',
          ),
        );

        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<SettingsState>().having(
              (s) => s.status,
              'status',
              SettingsStatus.loading,
            ),
            isA<SettingsState>()
                .having((s) => s.status, 'status', SettingsStatus.failure)
                .having((s) => s.error, 'error', SettingsError.importFailed),
          ]),
        );
      });
    });
  });
}
