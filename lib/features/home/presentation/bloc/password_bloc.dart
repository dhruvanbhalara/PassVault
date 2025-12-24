import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/usecases/password_usecases.dart';

// Events
abstract class PasswordEvent extends Equatable {
  const PasswordEvent();
  @override
  List<Object?> get props => [];
}

class LoadPasswords extends PasswordEvent {}

class AddPassword extends PasswordEvent {
  final PasswordEntry entry;
  const AddPassword(this.entry);
}

class UpdatePassword extends PasswordEvent {
  final PasswordEntry entry;
  const UpdatePassword(this.entry);
}

class DeletePassword extends PasswordEvent {
  final String id;
  const DeletePassword(this.id);
}

// States
sealed class PasswordState extends Equatable {
  const PasswordState();
  @override
  List<Object?> get props => [];
}

class PasswordInitial extends PasswordState {}

class PasswordLoading extends PasswordState {}

class PasswordLoaded extends PasswordState {
  final List<PasswordEntry> passwords;
  const PasswordLoaded(this.passwords);
  @override
  List<Object?> get props => [passwords];
}

class PasswordError extends PasswordState {
  final String message;
  const PasswordError(this.message);
  @override
  List<Object?> get props => [message];
}

@lazySingleton
class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final GetPasswordsUseCase _getPasswords;
  final SavePasswordUseCase _savePassword;
  final DeletePasswordUseCase _deletePassword;

  PasswordBloc(this._getPasswords, this._savePassword, this._deletePassword)
    : super(PasswordInitial()) {
    on<LoadPasswords>(_onLoadPasswords);
    on<AddPassword>(_onAddPassword);
    on<UpdatePassword>(_onUpdatePassword);
    on<DeletePassword>(_onDeletePassword);
  }

  Future<void> _onLoadPasswords(
    LoadPasswords event,
    Emitter<PasswordState> emit,
  ) async {
    emit(PasswordLoading());
    try {
      final passwords = await _getPasswords();
      emit(PasswordLoaded(passwords));
    } catch (e) {
      emit(PasswordError(e.toString()));
    }
  }

  Future<void> _onAddPassword(
    AddPassword event,
    Emitter<PasswordState> emit,
  ) async {
    try {
      await _savePassword(event.entry);
      add(LoadPasswords());
    } catch (e) {
      emit(PasswordError(e.toString()));
    }
  }

  Future<void> _onUpdatePassword(
    UpdatePassword event,
    Emitter<PasswordState> emit,
  ) async {
    try {
      await _savePassword(event.entry);
      add(LoadPasswords());
    } catch (e) {
      emit(PasswordError(e.toString()));
    }
  }

  Future<void> _onDeletePassword(
    DeletePassword event,
    Emitter<PasswordState> emit,
  ) async {
    try {
      await _deletePassword(event.id);
      add(LoadPasswords());
    } catch (e) {
      emit(PasswordError(e.toString()));
    }
  }
}
