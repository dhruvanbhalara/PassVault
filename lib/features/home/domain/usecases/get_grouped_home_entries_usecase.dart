import 'package:equatable/equatable.dart';
import 'package:passvault/core/error/error.dart';
import 'package:passvault/features/home/domain/entities/grouped_home_entry.dart';
import 'package:passvault/features/home/domain/services/credential_grouping_service.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/usecases/password_usecases.dart';

class GroupedHomeEntriesPayload extends Equatable {
  final List<PasswordEntry> passwords;
  final List<GroupedHomeEntry> groupedEntries;

  const GroupedHomeEntriesPayload({
    required this.passwords,
    required this.groupedEntries,
  });

  @override
  List<Object?> get props => [passwords, groupedEntries];
}

class GetGroupedHomeEntriesUseCase {
  final GetPasswordsUseCase _getPasswordsUseCase;
  final CredentialGroupingService _groupingService;

  const GetGroupedHomeEntriesUseCase(
    this._getPasswordsUseCase,
    this._groupingService,
  );

  Future<Result<GroupedHomeEntriesPayload>> call() async {
    final passwordsResult = await _getPasswordsUseCase();
    return passwordsResult.fold(
      Error.new,
      (passwords) => Success(
        GroupedHomeEntriesPayload(
          passwords: passwords,
          groupedEntries: _groupingService.group(passwords),
        ),
      ),
    );
  }
}
