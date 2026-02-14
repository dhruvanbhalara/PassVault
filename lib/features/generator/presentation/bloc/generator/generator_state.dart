part of 'generator_bloc.dart';

sealed class GeneratorState extends Equatable {
  const GeneratorState();

  @override
  List<Object?> get props => [];
}

final class GeneratorLoading extends GeneratorState {
  const GeneratorLoading();
}

final class GeneratorLoaded extends GeneratorState {
  final PasswordGenerationStrategy strategy;
  final String generatedPassword;
  final double strength;

  const GeneratorLoaded({
    required this.strategy,
    required this.generatedPassword,
    required this.strength,
  });

  @override
  List<Object?> get props => [strategy, generatedPassword, strength];
}
