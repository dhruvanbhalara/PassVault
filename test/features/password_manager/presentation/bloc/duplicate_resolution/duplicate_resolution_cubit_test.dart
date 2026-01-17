import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/presentation/bloc/duplicate_resolution/duplicate_resolution_cubit.dart';

void main() {
  late DuplicateResolutionCubit cubit;
  final testDuplicate = DuplicatePasswordEntry(
    existingEntry: PasswordEntry(
      id: '1',
      appName: 'App',
      username: 'User',
      password: 'Pass',
      lastUpdated: DateTime(2023),
    ),
    newEntry: PasswordEntry(
      id: '2',
      appName: 'App',
      username: 'User',
      password: 'Pass',
      lastUpdated: DateTime(2024),
    ),
    conflictReason: 'Reason',
  );

  setUp(() {
    cubit = DuplicateResolutionCubit([testDuplicate]);
  });

  group('DuplicateResolutionCubit', () {
    test('initial state has correct resolutions', () {
      expect(cubit.state.resolutions, [testDuplicate]);
      expect(cubit.state.hasUnresolved, isTrue);
    });

    blocTest<DuplicateResolutionCubit, DuplicateResolutionState>(
      'updateChoice updates specific resolution',
      build: () => cubit,
      act: (cubit) =>
          cubit.updateChoice(0, DuplicateResolutionChoice.keepExisting),
      expect: () => [
        isA<DuplicateResolutionState>().having(
          (s) => s.resolutions.first.userChoice,
          'userChoice',
          DuplicateResolutionChoice.keepExisting,
        ),
      ],
    );

    blocTest<DuplicateResolutionCubit, DuplicateResolutionState>(
      'setAllChoices updates all resolutions',
      build: () => cubit,
      act: (cubit) =>
          cubit.setAllChoices(DuplicateResolutionChoice.replaceWithNew),
      expect: () => [
        isA<DuplicateResolutionState>().having(
          (s) => s.resolutions.first.userChoice,
          'userChoice',
          DuplicateResolutionChoice.replaceWithNew,
        ),
      ],
    );
  });
}
