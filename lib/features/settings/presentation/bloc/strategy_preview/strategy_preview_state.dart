import 'package:equatable/equatable.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';

sealed class StrategyPreviewState extends Equatable {
  final String password;
  final PasswordFeedback strength;

  const StrategyPreviewState({
    this.password = '',
    this.strength = const PasswordFeedback.empty(),
  });

  @override
  List<Object?> get props => [password, strength];
}

final class StrategyPreviewInitial extends StrategyPreviewState {
  const StrategyPreviewInitial({super.password, super.strength});
}

final class StrategyPreviewLoading extends StrategyPreviewState {
  const StrategyPreviewLoading({super.password, super.strength});
}

final class StrategyPreviewSuccess extends StrategyPreviewState {
  const StrategyPreviewSuccess({
    required super.password,
    required super.strength,
  });
}

final class StrategyPreviewFailure extends StrategyPreviewState {
  final String errorMessage;

  const StrategyPreviewFailure({
    required this.errorMessage,
    super.password,
    super.strength,
  });

  @override
  List<Object?> get props => [...super.props, errorMessage];
}
