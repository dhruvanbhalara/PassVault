import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/failures.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/core/services/biometric_service.dart';
import 'package:passvault/core/services/data_service.dart';
import 'package:passvault/core/services/file_picker_service.dart';
import 'package:passvault/core/services/file_service.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/import_result.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/clear_all_passwords_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/import_passwords_usecase.dart';
import 'package:passvault/features/password_manager/domain/usecases/resolve_duplicates_usecase.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';

class MockBiometricService extends Mock implements BiometricService {}

class MockImportPasswordsUseCase extends Mock
    implements ImportPasswordsUseCase {}

class MockResolveDuplicatesUseCase extends Mock
    implements ResolveDuplicatesUseCase {}

class MockClearAllPasswordsUseCase extends Mock
    implements ClearAllPasswordsUseCase {}

class MockPasswordRepository extends Mock implements PasswordRepository {}

class MockDataService extends Mock implements DataService {}

class MockFileService extends Mock implements FileService {}

class MockFilePickerService extends Mock implements IFilePickerService {}

void main() {
  late ImportExportBloc bloc;
  late MockImportPasswordsUseCase mockImportUseCase;
  late MockResolveDuplicatesUseCase mockResolveUseCase;
  late MockClearAllPasswordsUseCase mockClearAllUseCase;
  late MockPasswordRepository mockPasswordRepository;
  late MockDataService mockDataService;
  late MockFileService mockFileService;
  late MockFilePickerService mockFilePickerService;
  late MockBiometricService mockBiometricService;

  final testEntries = [
    PasswordEntry(
      id: '1',
      appName: 'Test App',
      username: 'user',
      password: 'password',
      lastUpdated: DateTime(2024),
    ),
  ];

  setUpAll(() {
    registerFallbackValue(<PasswordEntry>[]);
    registerFallbackValue(<DuplicatePasswordEntry>[]);
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    mockImportUseCase = MockImportPasswordsUseCase();
    mockResolveUseCase = MockResolveDuplicatesUseCase();
    mockClearAllUseCase = MockClearAllPasswordsUseCase();
    mockPasswordRepository = MockPasswordRepository();
    mockDataService = MockDataService();
    mockFileService = MockFileService();
    mockFilePickerService = MockFilePickerService();
    mockBiometricService = MockBiometricService();

    // Default auth success
    when(
      () => mockBiometricService.authenticate(
        localizedReason: any(named: 'localizedReason'),
      ),
    ).thenAnswer((_) async => true);

    bloc = ImportExportBloc(
      mockImportUseCase,
      mockResolveUseCase,
      mockClearAllUseCase,
      mockPasswordRepository,
      mockDataService,
      mockFileService,
      mockFilePickerService,
    );
  });

  tearDown(() => bloc.close());

  group('$ImportExportBloc', () {
    group('$ExportDataEvent', () {
      blocTest<ImportExportBloc, ImportExportState>(
        'emits [Loading, ExportSuccess] when JSON export is successful',
        build: () {
          when(
            () => mockPasswordRepository.getPasswords(),
          ).thenAnswer((_) async => Success(testEntries));
          when(() => mockDataService.generateJson(any())).thenReturn('{}');
          when(
            () => mockFilePickerService.pickSavePath(
              fileName: any(named: 'fileName'),
              bytes: any(named: 'bytes'),
              allowedExtensions: any(named: 'allowedExtensions'),
            ),
          ).thenAnswer((_) async => '/path/to/save.json');
          return bloc;
        },
        act: (bloc) => bloc.add(const ExportDataEvent(isJson: true)),
        expect: () => [
          const ImportExportLoading(),
          const ExportSuccess('/path/to/save.json'),
        ],
      );

      blocTest<ImportExportBloc, ImportExportState>(
        'emits [Loading, Failure] when no data to export',
        build: () {
          when(
            () => mockPasswordRepository.getPasswords(),
          ).thenAnswer((_) async => const Success([]));
          return bloc;
        },
        act: (bloc) => bloc.add(const ExportDataEvent(isJson: true)),
        expect: () => [
          const ImportExportLoading(),
          const ImportExportFailure(
            DataMigrationError.noDataToExport,
            'No passwords found to export',
          ),
        ],
      );

      blocTest<ImportExportBloc, ImportExportState>(
        'emits [Loading, Initial] when export is cancelled by user',
        build: () {
          when(
            () => mockPasswordRepository.getPasswords(),
          ).thenAnswer((_) async => Success(testEntries));
          when(() => mockDataService.generateJson(any())).thenReturn('{}');
          when(
            () => mockFilePickerService.pickSavePath(
              fileName: any(named: 'fileName'),
              bytes: any(named: 'bytes'),
              allowedExtensions: any(named: 'allowedExtensions'),
            ),
          ).thenAnswer((_) async => null);
          return bloc;
        },
        act: (bloc) => bloc.add(const ExportDataEvent(isJson: true)),
        expect: () => [
          const ImportExportLoading(),
          const ImportExportInitial(),
        ],
      );
      group('$ImportDataEvent', () {
        blocTest<ImportExportBloc, ImportExportState>(
          'emits [Loading, ImportSuccess] when JSON import is successful',
          build: () {
            when(
              () => mockFilePickerService.pickFile(
                allowedExtensions: any(named: 'allowedExtensions'),
              ),
            ).thenAnswer((_) async => '/path/to/file.json');
            when(
              () => mockFileService.readAsString(any()),
            ).thenAnswer((_) async => '{}');
            when(
              () => mockDataService.importFromJson(any()),
            ).thenReturn(testEntries);
            when(() => mockImportUseCase(any())).thenAnswer(
              (_) async => const Success(
                ImportResult(
                  totalRecords: 1,
                  successfulImports: 1,
                  failedImports: 0,
                  duplicateEntries: [],
                  errors: [],
                ),
              ),
            );
            return bloc;
          },
          act: (bloc) => bloc.add(const ImportDataEvent(isJson: true)),
          expect: () => [const ImportExportLoading(), const ImportSuccess(1)],
        );

        blocTest<ImportExportBloc, ImportExportState>(
          'emits [Loading, DuplicatesDetected] when duplicates exist in import',
          build: () {
            when(
              () => mockFilePickerService.pickFile(
                allowedExtensions: any(named: 'allowedExtensions'),
              ),
            ).thenAnswer((_) async => '/path/to/file.json');
            when(
              () => mockFileService.readAsString(any()),
            ).thenAnswer((_) async => '{}');
            when(
              () => mockDataService.importFromJson(any()),
            ).thenReturn(testEntries);
            final duplicates = [
              DuplicatePasswordEntry(
                existingEntry: testEntries[0],
                newEntry: testEntries[0],
                conflictReason: 'reason',
              ),
            ];
            when(() => mockImportUseCase(any())).thenAnswer(
              (_) async => Success(
                ImportResult(
                  totalRecords: 1,
                  successfulImports: 0,
                  failedImports: 0,
                  duplicateEntries: duplicates,
                  errors: [],
                ),
              ),
            );
            return bloc;
          },
          act: (bloc) => bloc.add(const ImportDataEvent(isJson: true)),
          expect: () => [
            const ImportExportLoading(),
            isA<DuplicatesDetected>().having(
              (s) => s.duplicates.length,
              'duplicates count',
              1,
            ),
          ],
        );
      });

      group('Encrypted Operations', () {
        blocTest<ImportExportBloc, ImportExportState>(
          'emits [Loading, ImportEncryptedFileSelected] when encrypted file is picked',
          build: () {
            when(
              () => mockFilePickerService.pickFile(),
            ).thenAnswer((_) async => '/path/to/file.pvault');
            return bloc;
          },
          act: (bloc) => bloc.add(const PrepareImportEncryptedEvent()),
          expect: () => [
            const ImportExportLoading(),
            const ImportEncryptedFileSelected('/path/to/file.pvault'),
          ],
        );

        blocTest<ImportExportBloc, ImportExportState>(
          'emits [Loading, ExportSuccess] when encrypted export is successful',
          build: () {
            when(
              () => mockPasswordRepository.getPasswords(),
            ).thenAnswer((_) async => Success(testEntries));
            when(
              () => mockDataService.generateEncryptedJson(any(), any()),
            ).thenReturn(Uint8List(0));
            when(
              () => mockFilePickerService.pickSavePath(
                fileName: any(named: 'fileName'),
                bytes: any(named: 'bytes'),
                allowedExtensions: any(named: 'allowedExtensions'),
              ),
            ).thenAnswer((_) async => '/path/to/export.pvault');
            return bloc;
          },
          act: (bloc) => bloc.add(const ExportEncryptedEvent('password')),
          expect: () => [
            const ImportExportLoading(),
            const ExportSuccess('/path/to/export.pvault'),
          ],
        );

        blocTest<ImportExportBloc, ImportExportState>(
          'emits [Loading, ImportSuccess] when encrypted import succeeds with valid password',
          build: () {
            when(
              () => mockFilePickerService.pickFile(),
            ).thenAnswer((_) async => '/path/to/file.pvault');
            when(
              () => mockFileService.readAsBytes(any()),
            ).thenAnswer((_) async => Uint8List(0));
            when(
              () => mockDataService.importFromEncrypted(any(), any()),
            ).thenReturn([testEntries.first]);
            when(() => mockImportUseCase(any())).thenAnswer(
              (_) async => const Success(
                ImportResult(
                  totalRecords: 1,
                  successfulImports: 1,
                  failedImports: 0,
                  duplicateEntries: [],
                  errors: [],
                ),
              ),
            );
            return bloc;
          },
          act: (bloc) =>
              bloc.add(const ImportEncryptedEvent(password: 'correct')),
          expect: () => [const ImportExportLoading(), const ImportSuccess(1)],
        );

        blocTest<ImportExportBloc, ImportExportState>(
          'emits [Loading, Failure] when selected file extension is unsupported',
          build: () {
            when(
              () => mockFilePickerService.pickFile(),
            ).thenAnswer((_) async => '/path/to/file.txt');
            return bloc;
          },
          act: (bloc) =>
              bloc.add(const ImportEncryptedEvent(password: 'correct')),
          expect: () => [
            const ImportExportLoading(),
            const ImportExportFailure(
              DataMigrationError.invalidFormat,
              'Please select a .json, .csv, or .pvault file',
            ),
          ],
        );
      });

      group('$ClearDatabaseEvent', () {
        blocTest<ImportExportBloc, ImportExportState>(
          'emits [Loading, ClearDatabaseSuccess] when successful',
          build: () {
            when(
              () => mockClearAllUseCase(),
            ).thenAnswer((_) async => const Success(null));
            return bloc;
          },
          act: (bloc) => bloc.add(const ClearDatabaseEvent()),
          expect: () => [
            const ImportExportLoading(),
            const ClearDatabaseSuccess(),
          ],
        );
      });

      group('$ResetMigrationStatus', () {
        blocTest<ImportExportBloc, ImportExportState>(
          'emits [Initial]',
          build: () => bloc,
          act: (bloc) => bloc.add(const ResetMigrationStatus()),
          expect: () => [const ImportExportInitial()],
        );
      });
      group('$ResolveDuplicatesEvent', () {
        final duplicates = [
          DuplicatePasswordEntry(
            existingEntry: testEntries.first,
            newEntry: testEntries.first,
            conflictReason: 'reason',
          ),
        ];

        blocTest<ImportExportBloc, ImportExportState>(
          'emits [Loading, DuplicatesResolved] when resolutions are successful',
          build: () {
            when(
              () => mockResolveUseCase(any()),
            ).thenAnswer((_) async => const Success(null));
            return bloc;
          },
          act: (bloc) => bloc.add(ResolveDuplicatesEvent(duplicates)),
          expect: () => [
            // const ImportExportLoading('Authenticating...'), // Removed
            const ImportExportLoading(),
            const DuplicatesResolved(totalResolved: 1, totalImported: 1),
          ],
        );

        blocTest<ImportExportBloc, ImportExportState>(
          'emits [Loading, Failure] when resolution fails',
          build: () {
            when(() => mockResolveUseCase(any())).thenAnswer(
              (_) async => const Error(DataMigrationFailure('Failed')),
            );
            return bloc;
          },
          act: (bloc) => bloc.add(ResolveDuplicatesEvent(duplicates)),
          expect: () => [
            // const ImportExportLoading('Authenticating...'), // Removed
            const ImportExportLoading(),
            const ImportExportFailure(DataMigrationError.unknown, 'Failed'),
          ],
        );
      });
    });
  });
}
