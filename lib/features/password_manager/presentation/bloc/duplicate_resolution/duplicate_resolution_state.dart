part of 'duplicate_resolution_bloc.dart';

sealed class DuplicateResolutionState extends Equatable {
  final List<DuplicatePasswordEntry> resolutions;

  const DuplicateResolutionState({required this.resolutions});

  List<DuplicatePasswordEntry> get unresolved =>
      resolutions.where((r) => !r.isResolved).toList();

  bool get hasUnresolved => unresolved.isNotEmpty;

  @override
  List<Object?> get props => [resolutions];
}

final class DuplicateResolutionInitial extends DuplicateResolutionState {
  const DuplicateResolutionInitial({required super.resolutions});
}
