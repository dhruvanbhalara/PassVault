import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/error/failures.dart';
import 'package:passvault/core/error/result.dart';
import 'package:passvault/features/home/domain/services/credential_grouping_service.dart';
import 'package:passvault/features/home/domain/usecases/get_grouped_home_entries_usecase.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/usecases/password_usecases.dart';

class _MockGetPasswordsUseCase extends Mock implements GetPasswordsUseCase {}

void main() {
  const className = 'GetGroupedHomeEntriesUseCase';
  late _MockGetPasswordsUseCase getPasswordsUseCase;
  late GetGroupedHomeEntriesUseCase useCase;

  PasswordEntry makeEntry({
    required String id,
    required String appName,
    required String username,
    String? url,
  }) {
    return PasswordEntry(
      id: id,
      appName: appName,
      username: username,
      password: 'pw',
      lastUpdated: DateTime(2026, 1, 1),
      url: url,
    );
  }

  setUp(() {
    getPasswordsUseCase = _MockGetPasswordsUseCase();
    useCase = GetGroupedHomeEntriesUseCase(
      getPasswordsUseCase,
      const CredentialGroupingService(),
    );
  });

  group(className, () {
    test('returns grouped payload when repository call succeeds', () async {
      final rawEntries = [
        makeEntry(
          id: '1',
          appName: 'Example',
          username: 'first',
          url: 'https://www.example.com',
        ),
        makeEntry(
          id: '2',
          appName: 'Example',
          username: 'second',
          url: 'http://example.com',
        ),
      ];
      when(
        () => getPasswordsUseCase(),
      ).thenAnswer((_) async => Success(rawEntries));

      final result = await useCase();

      expect(result, isA<Success<GroupedHomeEntriesPayload>>());
      final payload = (result as Success<GroupedHomeEntriesPayload>).data;
      expect(payload.passwords, rawEntries);
      expect(payload.groupedEntries.length, 1);
      expect(payload.groupedEntries.single.canonicalKey, 'example.com');
      expect(payload.groupedEntries.single.members.length, rawEntries.length);
    });

    test('forwards failure when password retrieval fails', () async {
      when(
        () => getPasswordsUseCase(),
      ).thenAnswer((_) async => const Error(DatabaseFailure('storage-failed')));

      final result = await useCase();

      expect(
        result,
        const Error<GroupedHomeEntriesPayload>(
          DatabaseFailure('storage-failed'),
        ),
      );
    });
  });
}
