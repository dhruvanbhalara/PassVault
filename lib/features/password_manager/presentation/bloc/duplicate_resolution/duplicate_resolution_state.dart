part of 'duplicate_resolution_cubit.dart';

class DuplicateResolutionState extends Equatable {
  final List<DuplicatePasswordEntry> resolutions;

  const DuplicateResolutionState({required this.resolutions});

  DuplicateResolutionState copyWith({
    List<DuplicatePasswordEntry>? resolutions,
  }) {
    return DuplicateResolutionState(
      resolutions: resolutions ?? this.resolutions,
    );
  }

  List<DuplicatePasswordEntry> get unresolved =>
      resolutions.where((r) => !r.isResolved).toList();

  bool get hasUnresolved => unresolved.isNotEmpty;

  @override
  List<Object?> get props => [resolutions];
}
