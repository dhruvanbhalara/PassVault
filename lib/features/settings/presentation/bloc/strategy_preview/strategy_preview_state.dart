import 'package:equatable/equatable.dart';

enum StrategyPreviewStatus { initial, loading, success, failure }

class StrategyPreviewState extends Equatable {
  final StrategyPreviewStatus status;
  final String password;
  final String? errorMessage;

  const StrategyPreviewState({
    required this.status,
    this.password = '',
    this.errorMessage,
  });

  factory StrategyPreviewState.initial() => const StrategyPreviewState(
    status: StrategyPreviewStatus.initial,
    password: '',
  );

  StrategyPreviewState copyWith({
    StrategyPreviewStatus? status,
    String? password,
    String? errorMessage,
  }) {
    return StrategyPreviewState(
      status: status ?? this.status,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, password, errorMessage];
}
