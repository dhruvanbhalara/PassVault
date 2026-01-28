import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/presentation/bloc/duplicate_resolution/duplicate_resolution_bloc.dart';

void main() {
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

  group('$DuplicateResolutionBloc', () {
    test('initial state has correct resolutions', () {
      final bloc = DuplicateResolutionBloc([testDuplicate]);
      expect(bloc.state.resolutions, [testDuplicate]);
      expect(bloc.state.hasUnresolved, isTrue);
    });

    blocTest<DuplicateResolutionBloc, DuplicateResolutionState>(
      'ResolutionOptionUpdated updates specific resolution',
      build: () => DuplicateResolutionBloc([testDuplicate]),
      act: (bloc) => bloc.add(
        const ResolutionOptionUpdated(
          0,
          DuplicateResolutionChoice.keepExisting,
        ),
      ),
      expect: () => [
        isA<DuplicateResolutionState>().having(
          (s) => s.resolutions.first.userChoice,
          'userChoice',
          DuplicateResolutionChoice.keepExisting,
        ),
      ],
    );

    blocTest<DuplicateResolutionBloc, DuplicateResolutionState>(
      'BulkResolutionOptionSet updates all resolutions',
      build: () => DuplicateResolutionBloc([testDuplicate]),
      act: (bloc) => bloc.add(
        const BulkResolutionOptionSet(DuplicateResolutionChoice.replaceWithNew),
      ),
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
