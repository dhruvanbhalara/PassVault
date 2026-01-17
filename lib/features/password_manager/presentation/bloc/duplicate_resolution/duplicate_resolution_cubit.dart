import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';

part 'duplicate_resolution_state.dart';

class DuplicateResolutionCubit extends Cubit<DuplicateResolutionState> {
  DuplicateResolutionCubit(List<DuplicatePasswordEntry> duplicates)
    : super(DuplicateResolutionState(resolutions: duplicates));

  void updateChoice(int index, DuplicateResolutionChoice choice) {
    if (index < 0 || index >= state.resolutions.length) return;

    final updatedResolutions = List<DuplicatePasswordEntry>.from(
      state.resolutions,
    );
    updatedResolutions[index] = updatedResolutions[index].withChoice(choice);

    emit(state.copyWith(resolutions: updatedResolutions));
  }

  void setAllChoices(DuplicateResolutionChoice choice) {
    final updatedResolutions = state.resolutions
        .map((r) => r.withChoice(choice))
        .toList();

    emit(state.copyWith(resolutions: updatedResolutions));
  }
}
