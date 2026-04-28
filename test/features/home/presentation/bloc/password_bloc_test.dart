import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/failures.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/home/domain/entities/grouped_home_entry.dart';
import 'package:passvault/features/home/presentation/bloc/password/password_bloc.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/password_usecases.dart';

class MockGetPasswordsUseCase extends Mock implements GetPasswordsUseCase {}

class MockSavePasswordUseCase extends Mock implements SavePasswordUseCase {}

class MockDeletePasswordUseCase extends Mock implements DeletePasswordUseCase {}

class MockPasswordRepository extends Mock implements PasswordRepository {}

void main() {
  const className = 'PasswordBloc';
  late PasswordBloc bloc;
  late MockGetPasswordsUseCase mockGetPasswords;
  late MockSavePasswordUseCase mockSavePassword;
  late MockDeletePasswordUseCase mockDeletePassword;
  late MockPasswordRepository mockRepository;

  final entryOne = PasswordEntry(
    id: '1',
    appName: 'Example',
    username: 'first@example.com',
    password: 'pass1',
    lastUpdated: DateTime(2026, 1, 1),
    url: 'https://www.example.com',
    folder: 'work',
    favorite: true,
  );
  final entryTwo = PasswordEntry(
    id: '2',
    appName: 'Example',
    username: 'second@example.com',
    password: 'pass2',
    lastUpdated: DateTime(2026, 1, 2),
    url: 'http://example.com',
    folder: 'personal',
  );

  setUpAll(() {
    registerFallbackValue(entryOne);
  });

  setUp(() {
    mockGetPasswords = MockGetPasswordsUseCase();
    mockSavePassword = MockSavePasswordUseCase();
    mockDeletePassword = MockDeletePasswordUseCase();
    mockRepository = MockPasswordRepository();

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

  tearDown(() => bloc.close());

  Matcher loadedStateWith({
    required List<PasswordEntry> passwords,
    required int groupedCount,
    required int groupedMemberTotal,
  }) {
    return isA<PasswordLoaded>()
        .having((state) => state.passwords, 'passwords', passwords)
        .having(
          (state) => state.groupedEntries.length,
          'groupedEntries.length',
          groupedCount,
        )
        .having(
          (state) => state.groupedEntries.fold<int>(
            0,
            (sum, group) => sum + group.members.length,
          ),
          'grouped member total',
          groupedMemberTotal,
        );
  }

  group(className, () {
    test('initial state is PasswordInitial', () {
      expect(bloc.state, const PasswordInitial());
    });

    blocTest<PasswordBloc, PasswordState>(
      'LoadPasswords emits grouped loaded state on success',
      build: () {
        when(
          () => mockGetPasswords(),
        ).thenAnswer((_) async => Success([entryOne, entryTwo]));
        return bloc;
      },
      act: (testBloc) => testBloc.add(const LoadPasswords()),
      expect: () => [
        const PasswordLoading(),
        loadedStateWith(
          passwords: [entryOne, entryTwo],
          groupedCount: 1,
          groupedMemberTotal: 2,
        ),
      ],
      verify: (_) => verify(() => mockGetPasswords()).called(1),
    );

    blocTest<PasswordBloc, PasswordState>(
      'LoadPasswords emits error state on failure',
      build: () {
        when(
          () => mockGetPasswords(),
        ).thenAnswer((_) async => const Error(DatabaseFailure('error')));
        return bloc;
      },
      act: (testBloc) => testBloc.add(const LoadPasswords()),
      expect: () => [const PasswordLoading(), const PasswordError('error')],
    );

    blocTest<PasswordBloc, PasswordState>(
      'AddPassword updates loaded state incrementally and preserves grouping',
      build: () {
        when(
          () => mockSavePassword(any()),
        ).thenAnswer((_) async => const Success(null));
        return bloc;
      },
      seed: () => PasswordLoaded(
        passwords: [entryOne],
        groupedEntries: const [
          GroupedHomeEntry(
            canonicalKey: 'example.com',
            displayName: 'example.com',
            members: [],
          ),
        ],
      ),
      act: (testBloc) => testBloc.add(AddPassword(entryTwo)),
      expect: () => [
        loadedStateWith(
          passwords: [entryOne, entryTwo],
          groupedCount: 1,
          groupedMemberTotal: 2,
        ),
      ],
      verify: (_) {
        verify(() => mockSavePassword(any())).called(1);
        verifyNever(() => mockGetPasswords());
      },
    );

    blocTest<PasswordBloc, PasswordState>(
      'UpdatePassword updates member and preserves grouped structure',
      build: () {
        when(
          () => mockSavePassword(any()),
        ).thenAnswer((_) async => const Success(null));
        return bloc;
      },
      seed: () =>
          PasswordLoaded(passwords: [entryOne], groupedEntries: const []),
      act: (testBloc) => testBloc.add(
        UpdatePassword(entryOne.copyWith(username: 'new@example.com')),
      ),
      expect: () => [
        loadedStateWith(
          passwords: [entryOne.copyWith(username: 'new@example.com')],
          groupedCount: 1,
          groupedMemberTotal: 1,
        ),
      ],
    );

    blocTest<PasswordBloc, PasswordState>(
      'DeletePassword removes entry and preserves total count invariant',
      build: () {
        when(
          () => mockDeletePassword(any()),
        ).thenAnswer((_) async => const Success(null));
        return bloc;
      },
      seed: () => PasswordLoaded(
        passwords: [entryOne, entryTwo],
        groupedEntries: const [],
      ),
      act: (testBloc) => testBloc.add(const DeletePassword('2')),
      expect: () => [
        loadedStateWith(
          passwords: [entryOne],
          groupedCount: 1,
          groupedMemberTotal: 1,
        ),
      ],
    );

    blocTest<PasswordBloc, PasswordState>(
      'SearchPasswords filters grouped rows using grouped pipeline',
      build: () {
        when(
          () => mockGetPasswords(),
        ).thenAnswer((_) async => Success([entryOne, entryTwo]));
        return bloc;
      },
      act: (testBloc) async {
        testBloc.add(const LoadPasswords());
        await Future<void>.delayed(Duration.zero);
        testBloc.add(const SearchPasswords('first@example.com'));
      },
      expect: () => [
        const PasswordLoading(),
        loadedStateWith(
          passwords: [entryOne, entryTwo],
          groupedCount: 1,
          groupedMemberTotal: 2,
        ),
        isA<PasswordLoaded>()
            .having((state) => state.groupedEntries.length, 'group count', 1)
            .having(
              (state) => state.groupedEntries.single.members.length,
              'member count',
              1,
            )
            .having(
              (state) => state.searchQuery,
              'search query',
              'first@example.com',
            ),
      ],
    );

    blocTest<PasswordBloc, PasswordState>(
      'FilterPasswords applies favorites filter to grouped members',
      build: () {
        when(
          () => mockGetPasswords(),
        ).thenAnswer((_) async => Success([entryOne, entryTwo]));
        return bloc;
      },
      act: (testBloc) async {
        testBloc.add(const LoadPasswords());
        await Future<void>.delayed(Duration.zero);
        testBloc.add(const FilterPasswords(favoritesOnly: true));
      },
      expect: () => [
        const PasswordLoading(),
        loadedStateWith(
          passwords: [entryOne, entryTwo],
          groupedCount: 1,
          groupedMemberTotal: 2,
        ),
        isA<PasswordLoaded>()
            .having(
              (state) => state.groupedEntries.single.members.length,
              'favorite members',
              1,
            )
            .having((state) => state.favoritesOnly, 'favoritesOnly', true),
      ],
    );

    blocTest<PasswordBloc, PasswordState>(
      'AddPassword falls back to LoadPasswords when state is not loaded',
      build: () {
        when(
          () => mockSavePassword(any()),
        ).thenAnswer((_) async => const Success(null));
        when(
          () => mockGetPasswords(),
        ).thenAnswer((_) async => Success([entryOne]));
        return bloc;
      },
      act: (testBloc) => testBloc.add(AddPassword(entryOne)),
      expect: () => [
        const PasswordLoading(),
        loadedStateWith(
          passwords: [entryOne],
          groupedCount: 1,
          groupedMemberTotal: 1,
        ),
      ],
    );

    blocTest<PasswordBloc, PasswordState>(
      'UpdatePassword falls back to LoadPasswords when state is not loaded',
      build: () {
        when(
          () => mockSavePassword(any()),
        ).thenAnswer((_) async => const Success(null));
        when(
          () => mockGetPasswords(),
        ).thenAnswer((_) async => Success([entryOne]));
        return bloc;
      },
      act: (testBloc) => testBloc.add(UpdatePassword(entryOne)),
      expect: () => [
        const PasswordLoading(),
        loadedStateWith(
          passwords: [entryOne],
          groupedCount: 1,
          groupedMemberTotal: 1,
        ),
      ],
    );

    blocTest<PasswordBloc, PasswordState>(
      'DeletePassword falls back to LoadPasswords when state is not loaded',
      build: () {
        when(
          () => mockDeletePassword(any()),
        ).thenAnswer((_) async => const Success(null));
        when(
          () => mockGetPasswords(),
        ).thenAnswer((_) async => Success([entryOne]));
        return bloc;
      },
      act: (testBloc) => testBloc.add(const DeletePassword('1')),
      expect: () => [
        const PasswordLoading(),
        loadedStateWith(
          passwords: [entryOne],
          groupedCount: 1,
          groupedMemberTotal: 1,
        ),
      ],
    );

    test('listens to dataChanges stream and reloads grouped entries', () async {
      final controller = StreamController<void>();
      when(
        () => mockRepository.dataChanges,
      ).thenAnswer((_) => controller.stream);
      when(
        () => mockGetPasswords(),
      ).thenAnswer((_) async => Success([entryOne]));

      final testBloc = PasswordBloc(
        mockGetPasswords,
        mockSavePassword,
        mockDeletePassword,
        mockRepository,
      );

      controller.add(null);
      await Future<void>.delayed(Duration.zero);

      verify(() => mockGetPasswords()).called(1);
      await testBloc.close();
      await controller.close();
    });

    test('PasswordEvent props include grouped events', () {
      expect(const LoadPasswords().props, isEmpty);
      expect(const SearchPasswords('query').props, ['query']);
      expect(const FilterPasswords(folder: 'work', favoritesOnly: true).props, [
        'work',
        true,
      ]);
      expect(const ClearPasswordFilters().props, isEmpty);
      expect(AddPassword(entryOne).props, [entryOne]);
      expect(UpdatePassword(entryOne).props, [entryOne]);
      expect(const DeletePassword('1').props, ['1']);
    });
  });
}
