import 'package:equatable/equatable.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

sealed class AddEditPasswordState extends Equatable {
  final String generatedPassword;
  final PasswordFeedback strength;
  final PasswordGenerationSettings? settings;

  const AddEditPasswordState({
    this.generatedPassword = '',
    this.strength = const PasswordFeedback.empty(),
    this.settings,
  });

  @override
  List<Object?> get props => [generatedPassword, strength, settings];
}

final class AddEditInitial extends AddEditPasswordState {
  const AddEditInitial({
    super.generatedPassword,
    super.strength = const PasswordFeedback.empty(),
    super.settings,
  });
}

final class AddEditGenerated extends AddEditPasswordState {
  const AddEditGenerated({
    required super.generatedPassword,
    required super.strength,
    super.settings,
  });
}

final class AddEditSaving extends AddEditPasswordState {
  const AddEditSaving({
    super.generatedPassword,
    required super.strength,
    super.settings,
  });
}

final class AddEditSuccess extends AddEditPasswordState {
  const AddEditSuccess({
    super.generatedPassword,
    required super.strength,
    super.settings,
  });
}

final class AddEditFailure extends AddEditPasswordState {
  final String errorMessage;

  const AddEditFailure({
    required this.errorMessage,
    super.generatedPassword,
    required super.strength,
    super.settings,
  });

  @override
  List<Object?> get props => [...super.props, errorMessage];
}

final class AddEditLoading extends AddEditPasswordState {
  const AddEditLoading({
    super.generatedPassword,
    required super.strength,
    super.settings,
  });
}

final class AddEditLoaded extends AddEditPasswordState {
  final PasswordEntry entry;
  const AddEditLoaded({
    required this.entry,
    super.generatedPassword,
    required super.strength,
    super.settings,
  });
  @override
  List<Object?> get props => [entry, ...super.props];
}
