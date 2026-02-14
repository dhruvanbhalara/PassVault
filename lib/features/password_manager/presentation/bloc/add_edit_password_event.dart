import 'package:equatable/equatable.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

sealed class AddEditPasswordEvent extends Equatable {
  const AddEditPasswordEvent();
  @override
  List<Object?> get props => [];
}

final class LoadEntry extends AddEditPasswordEvent {
  final String id;
  const LoadEntry(this.id);
  @override
  List<Object?> get props => [id];
}

class LoadGenerationSettings extends AddEditPasswordEvent {}

class GenerateStrongPassword extends AddEditPasswordEvent {
  final String? strategyId;
  const GenerateStrongPassword({this.strategyId});

  @override
  List<Object?> get props => [strategyId];
}

final class PasswordChanged extends AddEditPasswordEvent {
  final String password;
  const PasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

final class SaveEntry extends AddEditPasswordEvent {
  final PasswordEntry entry;
  const SaveEntry(this.entry);
  @override
  List<Object?> get props => [entry];
}
