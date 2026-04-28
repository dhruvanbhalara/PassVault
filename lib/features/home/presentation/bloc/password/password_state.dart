part of 'password_bloc.dart';

sealed class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object?> get props => [];
}

class PasswordInitial extends PasswordState {
  const PasswordInitial();
}

class PasswordLoading extends PasswordState {
  const PasswordLoading();
}

class PasswordLoaded extends PasswordState {
  final List<PasswordEntry> passwords;
  final List<GroupedHomeEntry> groupedEntries;
  final String searchQuery;
  final String? folderFilter;
  final bool favoritesOnly;

  const PasswordLoaded({
    required this.passwords,
    required this.groupedEntries,
    this.searchQuery = '',
    this.folderFilter,
    this.favoritesOnly = false,
  });

  @override
  List<Object?> get props => [
    passwords,
    groupedEntries,
    searchQuery,
    folderFilter,
    favoritesOnly,
  ];
}

class PasswordError extends PasswordState {
  final String message;
  const PasswordError(this.message);

  @override
  List<Object?> get props => [message];
}
