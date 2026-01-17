import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/utils/app_logger.dart';
import 'package:passvault/features/home/presentation/bloc/password_event.dart';
import 'package:passvault/features/home/presentation/bloc/password_state.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/password_usecases.dart';

export 'password_event.dart';
export 'password_state.dart';

@lazySingleton
class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final GetPasswordsUseCase _getPasswords;
  final SavePasswordUseCase _savePassword;
  final DeletePasswordUseCase _deletePassword;
  final PasswordRepository _repository;

  // Stream subscription for external data changes
  StreamSubscription<void>? _dataChangeSubscription;

  PasswordBloc(
    this._getPasswords,
    this._savePassword,
    this._deletePassword,
    this._repository,
  ) : super(const PasswordInitial()) {
    on<LoadPasswords>(_onLoadPasswords);
    on<AddPassword>(_onAddPassword);
    on<UpdatePassword>(_onUpdatePassword);
    on<DeletePassword>(_onDeletePassword);

    // Subscribe to repository data changes for cross-screen sync
    _dataChangeSubscription = _repository.dataChanges.listen((_) {
      AppLogger.debug(
        'External data change detected, reloading passwords',
        tag: 'PasswordBloc',
      );
      add(const LoadPasswords());
    });

    AppLogger.debug(
      'PasswordBloc initialized with stream subscription',
      tag: 'PasswordBloc',
    );
  }

  @override
  Future<void> close() {
    AppLogger.debug('Canceling data change subscription', tag: 'PasswordBloc');
    _dataChangeSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadPasswords(
    LoadPasswords event,
    Emitter<PasswordState> emit,
  ) async {
    AppLogger.info('Loading passwords from repository', tag: 'PasswordBloc');
    emit(const PasswordLoading());
    final result = await _getPasswords();
    result.fold(
      (failure) {
        AppLogger.error(
          'Failed to load passwords: ${failure.message}',
          tag: 'PasswordBloc',
        );
        emit(PasswordError(failure.message));
      },
      (passwords) {
        AppLogger.info(
          'Loaded ${passwords.length} passwords',
          tag: 'PasswordBloc',
        );
        emit(PasswordLoaded(passwords));
      },
    );
  }

  Future<void> _onAddPassword(
    AddPassword event,
    Emitter<PasswordState> emit,
  ) async {
    final result = await _savePassword(event.entry);
    result.fold((failure) => emit(PasswordError(failure.message)), (_) {
      if (state is PasswordLoaded) {
        final currentPasswords = (state as PasswordLoaded).passwords;
        emit(PasswordLoaded([...currentPasswords, event.entry]));
      } else {
        // Fallback: load all if state is not loaded
        add(const LoadPasswords());
      }
    });
  }

  Future<void> _onUpdatePassword(
    UpdatePassword event,
    Emitter<PasswordState> emit,
  ) async {
    final result = await _savePassword(event.entry);
    result.fold((failure) => emit(PasswordError(failure.message)), (_) {
      if (state is PasswordLoaded) {
        final currentPasswords = (state as PasswordLoaded).passwords;
        final updatedList = currentPasswords.map((p) {
          return p.id == event.entry.id ? event.entry : p;
        }).toList();
        emit(PasswordLoaded(updatedList));
      } else {
        // Fallback: load all if state is not loaded
        add(const LoadPasswords());
      }
    });
  }

  Future<void> _onDeletePassword(
    DeletePassword event,
    Emitter<PasswordState> emit,
  ) async {
    final result = await _deletePassword(event.id);
    result.fold((failure) => emit(PasswordError(failure.message)), (_) {
      if (state is PasswordLoaded) {
        final currentPasswords = (state as PasswordLoaded).passwords;
        final filteredList = currentPasswords
            .where((p) => p.id != event.id)
            .toList();
        emit(PasswordLoaded(filteredList));
      } else {
        // Fallback: load all if state is not loaded
        add(const LoadPasswords());
      }
    });
  }
}
