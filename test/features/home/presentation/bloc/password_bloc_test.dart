import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/failures.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/home/presentation/bloc/password/password_bloc.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/password_usecases.dart';

class MockGetPasswordsUseCase extends Mock implements GetPasswordsUseCase {}

class MockSavePasswordUseCase extends Mock implements SavePasswordUseCase {}

class MockDeletePasswordUseCase extends Mock implements DeletePasswordUseCase {}

class MockPasswordRepository extends Mock implements PasswordRepository {}

void main() {
  late PasswordBloc bloc;
  late MockGetPasswordsUseCase mockGetPasswords;
  late MockSavePasswordUseCase mockSavePassword;
  late MockDeletePasswordUseCase mockDeletePassword;
  late MockPasswordRepository mockRepository;

  final tEntry = PasswordEntry(
    id: '1',
    appName: 'App1',
    username: 'user1',
    password: 'pass1',
    lastUpdated: DateTime(2024, 1, 1),
  );

  setUp(() {
    mockGetPasswords = MockGetPasswordsUseCase();
    mockSavePassword = MockSavePasswordUseCase();
    mockDeletePassword = MockDeletePasswordUseCase();
    mockRepository = MockPasswordRepository();

    // Mock the dataChanges stream to return empty stream
    when(
      () => mockRepository.dataChanges,
    ).thenAnswer((_) => const Stream<void>.empty());

    bloc = PasswordBloc(
      mockGetPasswords,
      mockSavePassword,
      mockDeletePassword,
      mockRepository,
    );
  });

  setUpAll(() {
    registerFallbackValue(tEntry);
  });

  tearDown(() => bloc.close());

  group('$PasswordBloc', () {
    test('initial state is PasswordInitial', () {
      expect(bloc.state, const PasswordInitial());
    });

    blocTest<PasswordBloc, PasswordState>(
      'on LoadPasswords should emit [Loading, Loaded] on success',
      build: () {
        when(
          () => mockGetPasswords(),
        ).thenAnswer((_) async => Success([tEntry]));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadPasswords()),
      expect: () => [
        const PasswordLoading(),
        PasswordLoaded([tEntry]),
      ],
      verify: (_) => verify(() => mockGetPasswords()).called(1),
    );

    blocTest<PasswordBloc, PasswordState>(
      'on AddPassword should update state incrementally if already loaded',
      build: () {
        when(
          () => mockSavePassword(any()),
        ).thenAnswer((_) async => const Success(null));
        return bloc;
      },
      seed: () => PasswordLoaded([tEntry]),
      act: (bloc) =>
          bloc.add(AddPassword(tEntry.copyWith(id: '2', appName: 'App2'))),
      expect: () => [
        PasswordLoaded([tEntry, tEntry.copyWith(id: '2', appName: 'App2')]),
      ],
      verify: (_) {
        verify(() => mockSavePassword(any())).called(1);
        // Verify that getPasswords was NOT called (incremental update)
        verifyNever(() => mockGetPasswords());
      },
    );

    blocTest<PasswordBloc, PasswordState>(
      'on UpdatePassword should update state incrementally if already loaded',
      build: () {
        when(
          () => mockSavePassword(any()),
        ).thenAnswer((_) async => const Success(null));
        return bloc;
      },
      seed: () => PasswordLoaded([tEntry]),
      act: (bloc) =>
          bloc.add(UpdatePassword(tEntry.copyWith(appName: 'Updated App'))),
      expect: () => [
        PasswordLoaded([tEntry.copyWith(appName: 'Updated App')]),
      ],
      verify: (_) {
        verify(() => mockSavePassword(any())).called(1);
        verifyNever(() => mockGetPasswords());
      },
    );

    blocTest<PasswordBloc, PasswordState>(
      'on DeletePassword should remove from state incrementally if already loaded',
      build: () {
        when(
          () => mockDeletePassword(any()),
        ).thenAnswer((_) async => const Success(null));
        return bloc;
      },
      seed: () => PasswordLoaded([tEntry]),
      act: (bloc) => bloc.add(const DeletePassword('1')),
      expect: () => [const PasswordLoaded([])],
      verify: (_) {
        verify(() => mockDeletePassword('1')).called(1);
        verifyNever(() => mockGetPasswords());
      },
    );

    blocTest<PasswordBloc, PasswordState>(
      'on LoadPasswords should emit [Loading, Error] on failure',
      build: () {
        when(
          () => mockGetPasswords(),
        ).thenAnswer((_) async => const Error(DatabaseFailure('error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadPasswords()),
      expect: () => [const PasswordLoading(), const PasswordError('error')],
    );

    group('Error and Fallback branches', () {
      blocTest<PasswordBloc, PasswordState>(
        'on AddPassword should reload if state is not PasswordLoaded',
        build: () {
          when(
            () => mockSavePassword(any()),
          ).thenAnswer((_) async => const Success(null));
          when(
            () => mockGetPasswords(),
          ).thenAnswer((_) async => Success([tEntry]));
          return bloc;
        },
        act: (bloc) => bloc.add(AddPassword(tEntry)),
        expect: () => [
          const PasswordLoading(),
          PasswordLoaded([tEntry]),
        ],
        verify: (_) {
          verify(() => mockSavePassword(any())).called(1);
          verify(() => mockGetPasswords()).called(1);
        },
      );

      blocTest<PasswordBloc, PasswordState>(
        'on UpdatePassword should reload if state is not PasswordLoaded',
        build: () {
          when(
            () => mockSavePassword(any()),
          ).thenAnswer((_) async => const Success(null));
          when(
            () => mockGetPasswords(),
          ).thenAnswer((_) async => Success([tEntry]));
          return bloc;
        },
        act: (bloc) => bloc.add(UpdatePassword(tEntry)),
        expect: () => [
          const PasswordLoading(),
          PasswordLoaded([tEntry]),
        ],
      );

      blocTest<PasswordBloc, PasswordState>(
        'on DeletePassword should reload if state is not PasswordLoaded',
        build: () {
          when(
            () => mockDeletePassword(any()),
          ).thenAnswer((_) async => const Success(null));
          when(
            () => mockGetPasswords(),
          ).thenAnswer((_) async => Success([tEntry]));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeletePassword('1')),
        expect: () => [
          const PasswordLoading(),
          PasswordLoaded([tEntry]),
        ],
      );

      blocTest<PasswordBloc, PasswordState>(
        'on AddPassword emits PasswordError on failure',
        build: () {
          when(
            () => mockSavePassword(any()),
          ).thenAnswer((_) async => const Error(DatabaseFailure('fail')));
          return bloc;
        },
        act: (bloc) => bloc.add(AddPassword(tEntry)),
        expect: () => [const PasswordError('fail')],
      );

      blocTest<PasswordBloc, PasswordState>(
        'on UpdatePassword emits PasswordError on failure',
        build: () {
          when(
            () => mockSavePassword(any()),
          ).thenAnswer((_) async => const Error(DatabaseFailure('fail')));
          return bloc;
        },
        act: (bloc) => bloc.add(UpdatePassword(tEntry)),
        expect: () => [const PasswordError('fail')],
      );

      blocTest<PasswordBloc, PasswordState>(
        'on DeletePassword emits PasswordError on failure',
        build: () {
          when(
            () => mockDeletePassword(any()),
          ).thenAnswer((_) async => const Error(DatabaseFailure('fail')));
          return bloc;
        },
        act: (bloc) => bloc.add(const DeletePassword('1')),
        expect: () => [const PasswordError('fail')],
      );
    });

    group('External Data Changes & Close', () {
      test(
        'listens to repository dataChanges and fires LoadPasswords',
        () async {
          // We need a proper StreamController to emit events
          final controller = StreamController<void>();
          when(
            () => mockRepository.dataChanges,
          ).thenAnswer((_) => controller.stream);
          when(
            () => mockGetPasswords(),
          ).thenAnswer((_) async => Success([tEntry]));

          // Re-init bloc to pick up the mocked stream
          final testBloc = PasswordBloc(
            mockGetPasswords,
            mockSavePassword,
            mockDeletePassword,
            mockRepository,
          );

          // Emit an event on the stream and wait for bloc to process it
          controller.add(null);
          await Future.delayed(Duration.zero);

          verify(() => mockGetPasswords()).called(1);
          await testBloc.close();
          await controller.close();
        },
      );

      test('close() cleans up subscriptions properly', () async {
        final b = PasswordBloc(
          mockGetPasswords,
          mockSavePassword,
          mockDeletePassword,
          mockRepository,
        );
        await b.close();
        // Just verify it doesn't crash on close
        expect(b.state, isA<PasswordState>());
      });
    });

    group('PasswordEvent props', () {
      test('props are correct', () {
        expect(const LoadPasswords().props, isEmpty);
        expect(AddPassword(tEntry).props, [tEntry]);
        expect(UpdatePassword(tEntry).props, [tEntry]);
        expect(const DeletePassword('1').props, ['1']);
      });
    });
  });
}
