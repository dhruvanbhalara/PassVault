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
    });
  });
}
