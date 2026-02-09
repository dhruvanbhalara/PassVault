import 'package:equatable/equatable.dart';

sealed class StrategyPreviewState extends Equatable {
  final String password;

  const StrategyPreviewState({this.password = ''});

  @override
  List<Object?> get props => [password];
}

final class StrategyPreviewInitial extends StrategyPreviewState {
  const StrategyPreviewInitial({super.password});
}

final class StrategyPreviewLoading extends StrategyPreviewState {
  const StrategyPreviewLoading({super.password});
}

final class StrategyPreviewSuccess extends StrategyPreviewState {
  const StrategyPreviewSuccess({required super.password});
}

final class StrategyPreviewFailure extends StrategyPreviewState {
  final String errorMessage;

  const StrategyPreviewFailure({required this.errorMessage, super.password});

  @override
  List<Object?> get props => [...super.props, errorMessage];
}
