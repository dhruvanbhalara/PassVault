import 'package:equatable/equatable.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

sealed class AddEditPasswordState extends Equatable {
  final String generatedPassword;
  final double strength;
  final PasswordGenerationSettings? settings;

  const AddEditPasswordState({
    this.generatedPassword = '',
    this.strength = 0.0,
    this.settings,
  });

  @override
  List<Object?> get props => [generatedPassword, strength, settings];
}

final class AddEditInitial extends AddEditPasswordState {
  const AddEditInitial({
    super.generatedPassword,
    super.strength,
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
    super.strength,
    super.settings,
  });
}

final class AddEditSuccess extends AddEditPasswordState {
  const AddEditSuccess({
    super.generatedPassword,
    super.strength,
    super.settings,
  });
}

final class AddEditFailure extends AddEditPasswordState {
  final String errorMessage;

  const AddEditFailure({
    required this.errorMessage,
    super.generatedPassword,
    super.strength,
    super.settings,
  });

  @override
  List<Object?> get props => [...super.props, errorMessage];
}
