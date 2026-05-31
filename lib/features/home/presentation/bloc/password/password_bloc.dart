import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/utils/app_logger.dart';
import 'package:passvault/features/home/domain/entities/grouped_home_entry.dart';
import 'package:passvault/features/home/domain/services/credential_grouping_service.dart';
import 'package:passvault/features/home/domain/usecases/get_grouped_home_entries_usecase.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/repositories/password_repository.dart';
import 'package:passvault/features/password_manager/domain/usecases/password_usecases.dart';

part 'password_event.dart';
part 'password_state.dart';

@lazySingleton
class PasswordBloc extends Bloc<PasswordEvent, PasswordState> {
  final GetPasswordsUseCase _getPasswords;
  final SavePasswordUseCase _savePassword;
  final DeletePasswordUseCase _deletePassword;
  final PasswordRepository _repository;
  late final CredentialGroupingService _groupingService;
  late final GetGroupedHomeEntriesUseCase _getGroupedHomeEntries;
  String _searchQuery = '';
  String? _folderFilter;
  bool _favoritesOnly = false;

  // Stream subscription for external data changes
  StreamSubscription<void>? _dataChangeSubscription;

  PasswordBloc(
    this._getPasswords,
    this._savePassword,
    this._deletePassword,
    this._repository,
  ) : super(const PasswordInitial()) {
    _groupingService = const CredentialGroupingService();
    _getGroupedHomeEntries = GetGroupedHomeEntriesUseCase(
      _getPasswords,
      _groupingService,
    );

    on<LoadPasswords>(_onLoadPasswords);
    on<SearchPasswords>(_onSearchPasswords);
    on<FilterPasswords>(_onFilterPasswords);
    on<ClearPasswordFilters>(_onClearPasswordFilters);
    on<AddPassword>(_onAddPassword);
    on<UpdatePassword>(_onUpdatePassword);
    on<DeletePassword>(_onDeletePassword);

    // Subscribe to repository data changes for cross-screen sync
    _dataChangeSubscription = _repository.dataChanges.listen((_) {
      if (isClosed) return;
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
    _dataChangeSubscription = null;
    return super.close();
  }

  Future<void> _onLoadPasswords(
    LoadPasswords event,
    Emitter<PasswordState> emit,
  ) async {
    AppLogger.info('Loading passwords from repository', tag: 'PasswordBloc');
    emit(const PasswordLoading());
    final result = await _getGroupedHomeEntries();
    result.fold(
      (failure) {
        AppLogger.error(
          'Failed to load passwords: ${failure.message}',
          tag: 'PasswordBloc',
        );
        emit(PasswordError(failure.message));
      },
      (payload) {
        AppLogger.info(
          'Loaded ${payload.passwords.length} passwords',
          tag: 'PasswordBloc',
        );
        _emitLoaded(
          emit: emit,
          passwords: payload.passwords,
          groupedEntries: payload.groupedEntries,
        );
      },
    );
  }

  void _onSearchPasswords(SearchPasswords event, Emitter<PasswordState> emit) {
    _searchQuery = event.query.trim().toLowerCase();
    final currentState = state;
    if (currentState is! PasswordLoaded) {
      return;
    }

    _emitLoaded(
      emit: emit,
      passwords: currentState.passwords,
      groupedEntries: _groupingService.group(currentState.passwords),
    );
  }

  void _onFilterPasswords(FilterPasswords event, Emitter<PasswordState> emit) {
    _folderFilter = event.folder?.trim();
    _favoritesOnly = event.favoritesOnly;
    final currentState = state;
    if (currentState is! PasswordLoaded) {
      return;
    }

    _emitLoaded(
      emit: emit,
      passwords: currentState.passwords,
      groupedEntries: _groupingService.group(currentState.passwords),
    );
  }

  void _onClearPasswordFilters(
    ClearPasswordFilters event,
    Emitter<PasswordState> emit,
  ) {
    _searchQuery = '';
    _folderFilter = null;
    _favoritesOnly = false;
    final currentState = state;
    if (currentState is! PasswordLoaded) {
      return;
    }

    _emitLoaded(
      emit: emit,
      passwords: currentState.passwords,
      groupedEntries: _groupingService.group(currentState.passwords),
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
        _emitLoadedFromRaw([...currentPasswords, event.entry], emit);
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
        _emitLoadedFromRaw(updatedList, emit);
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
        _emitLoadedFromRaw(filteredList, emit);
      } else {
        // Fallback: load all if state is not loaded
        add(const LoadPasswords());
      }
    });
  }

  void _emitLoadedFromRaw(
    List<PasswordEntry> passwords,
    Emitter<PasswordState> emit,
  ) {
    _emitLoaded(
      emit: emit,
      passwords: passwords,
      groupedEntries: _groupingService.group(passwords),
    );
  }

  void _emitLoaded({
    required Emitter<PasswordState> emit,
    required List<PasswordEntry> passwords,
    required List<GroupedHomeEntry> groupedEntries,
  }) {
    emit(
      PasswordLoaded(
        passwords: passwords,
        groupedEntries: _applySearchAndFilters(groupedEntries),
        searchQuery: _searchQuery,
        folderFilter: _folderFilter,
        favoritesOnly: _favoritesOnly,
      ),
    );
  }

  List<GroupedHomeEntry> _applySearchAndFilters(List<GroupedHomeEntry> groups) {
    if (_searchQuery.isEmpty && _folderFilter == null && !_favoritesOnly) {
      return groups;
    }

    final normalizedFolder = _folderFilter?.toLowerCase();
    final filteredGroups = <GroupedHomeEntry>[];

    for (final group in groups) {
      final filteredMembers = group.members.where((member) {
        if (normalizedFolder != null) {
          final memberFolder = member.folder?.toLowerCase();
          if (memberFolder != normalizedFolder) {
            return false;
          }
        }
        if (_favoritesOnly && !member.favorite) {
          return false;
        }
        if (_searchQuery.isEmpty) {
          return true;
        }

        final searchableValues = <String>[
          group.displayName.toLowerCase(),
          group.canonicalKey.toLowerCase(),
          member.appName.toLowerCase(),
          member.username.toLowerCase(),
          (member.url ?? '').toLowerCase(),
        ];
        return searchableValues.any((value) => value.contains(_searchQuery));
      }).toList();

      if (filteredMembers.isNotEmpty) {
        filteredGroups.add(
          GroupedHomeEntry(
            canonicalKey: group.canonicalKey,
            displayName: group.displayName,
            members: filteredMembers,
          ),
        );
      }
    }

    return filteredGroups;
  }
}
