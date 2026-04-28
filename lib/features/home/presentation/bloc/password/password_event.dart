part of 'password_bloc.dart';

sealed class PasswordEvent extends Equatable {
  const PasswordEvent();

  @override
  List<Object?> get props => [];
}

class LoadPasswords extends PasswordEvent {
  const LoadPasswords();
}

class SearchPasswords extends PasswordEvent {
  final String query;
  const SearchPasswords(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterPasswords extends PasswordEvent {
  final String? folder;
  final bool favoritesOnly;

  const FilterPasswords({this.folder, this.favoritesOnly = false});

  @override
  List<Object?> get props => [folder, favoritesOnly];
}

class ClearPasswordFilters extends PasswordEvent {
  const ClearPasswordFilters();
}

class AddPassword extends PasswordEvent {
  final PasswordEntry entry;
  const AddPassword(this.entry);

  @override
  List<Object?> get props => [entry];
}

class UpdatePassword extends PasswordEvent {
  final PasswordEntry entry;
  const UpdatePassword(this.entry);

  @override
  List<Object?> get props => [entry];
}

class DeletePassword extends PasswordEvent {
  final String id;
  const DeletePassword(this.id);

  @override
  List<Object?> get props => [id];
}
