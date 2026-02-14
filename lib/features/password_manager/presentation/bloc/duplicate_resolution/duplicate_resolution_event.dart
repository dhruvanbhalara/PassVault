part of 'duplicate_resolution_bloc.dart';

sealed class DuplicateResolutionEvent extends Equatable {
  const DuplicateResolutionEvent();

  @override
  List<Object?> get props => [];
}

class ResolutionOptionUpdated extends DuplicateResolutionEvent {
  final int index;
  final DuplicateResolutionChoice choice;

  const ResolutionOptionUpdated(this.index, this.choice);

  @override
  List<Object?> get props => [index, choice];
}

class BulkResolutionOptionSet extends DuplicateResolutionEvent {
  final DuplicateResolutionChoice choice;

  const BulkResolutionOptionSet(this.choice);

  @override
  List<Object?> get props => [choice];
}
