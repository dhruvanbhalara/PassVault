import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/presentation/bloc/duplicate_resolution/duplicate_resolution_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/duplicate_resolution/duplicate_resolution_state.dart';

export 'duplicate_resolution_event.dart';
export 'duplicate_resolution_state.dart';

class DuplicateResolutionBloc
    extends Bloc<DuplicateResolutionEvent, DuplicateResolutionState> {
  DuplicateResolutionBloc(List<DuplicatePasswordEntry> duplicates)
    : super(DuplicateResolutionInitial(resolutions: duplicates)) {
    on<ResolutionOptionUpdated>(_onResolutionOptionUpdated);
    on<BulkResolutionOptionSet>(_onBulkResolutionOptionSet);
  }

  void _onResolutionOptionUpdated(
    ResolutionOptionUpdated event,
    Emitter<DuplicateResolutionState> emit,
  ) {
    if (event.index < 0 || event.index >= state.resolutions.length) return;

    final updatedResolutions = List<DuplicatePasswordEntry>.from(
      state.resolutions,
    );
    updatedResolutions[event.index] = updatedResolutions[event.index]
        .withChoice(event.choice);

    emit(DuplicateResolutionInitial(resolutions: updatedResolutions));
  }

  void _onBulkResolutionOptionSet(
    BulkResolutionOptionSet event,
    Emitter<DuplicateResolutionState> emit,
  ) {
    final updatedResolutions = state.resolutions
        .map((r) => r.withChoice(event.choice))
        .toList();

    emit(DuplicateResolutionInitial(resolutions: updatedResolutions));
  }
}
