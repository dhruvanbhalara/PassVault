import 'package:equatable/equatable.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

/// Represents a duplicate password detected during import.
///
/// Contains both the existing entry already in PassVault and the new
/// imported entry, allowing the user to make an informed decision on
/// how to resolve the conflict.
class DuplicatePasswordEntry extends Equatable {
  /// The password entry already stored in PassVault
  final PasswordEntry existingEntry;

  /// The new password entry from the import file
  final PasswordEntry newEntry;

  /// Explanation of why these entries are considered duplicates
  final String conflictReason;

  /// User's resolution choice (null until user decides)
  final DuplicateResolutionChoice? userChoice;

  const DuplicatePasswordEntry({
    required this.existingEntry,
    required this.newEntry,
    required this.conflictReason,
    this.userChoice,
  });

  /// Create a copy with updated user choice
  DuplicatePasswordEntry withChoice(DuplicateResolutionChoice choice) {
    return DuplicatePasswordEntry(
      existingEntry: existingEntry,
      newEntry: newEntry,
      conflictReason: conflictReason,
      userChoice: choice,
    );
  }

  /// Returns true if user has made a choice for this duplicate.
  bool get isResolved => userChoice != null;

  /// Creates a copy with updated fields.
  DuplicatePasswordEntry copyWith({
    PasswordEntry? existingEntry,
    PasswordEntry? newEntry,
    String? conflictReason,
    DuplicateResolutionChoice? userChoice,
  }) {
    return DuplicatePasswordEntry(
      existingEntry: existingEntry ?? this.existingEntry,
      newEntry: newEntry ?? this.newEntry,
      conflictReason: conflictReason ?? this.conflictReason,
      userChoice: userChoice ?? this.userChoice,
    );
  }

  @override
  List<Object?> get props => [
    existingEntry,
    newEntry,
    conflictReason,
    userChoice,
  ];
}
