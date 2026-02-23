part of 'generator_bloc.dart';

sealed class GeneratorEvent extends Equatable {
  const GeneratorEvent();

  @override
  List<Object?> get props => [];
}

final class GeneratorStarted extends GeneratorEvent {
  const GeneratorStarted();
}

final class GeneratorRequested extends GeneratorEvent {
  const GeneratorRequested();
}

final class GeneratorLengthChanged extends GeneratorEvent {
  final int length;
  const GeneratorLengthChanged(this.length);

  @override
  List<Object?> get props => [length];
}

final class GeneratorUppercaseToggled extends GeneratorEvent {
  final bool value;
  const GeneratorUppercaseToggled(this.value);

  @override
  List<Object?> get props => [value];
}

final class GeneratorLowercaseToggled extends GeneratorEvent {
  final bool value;
  const GeneratorLowercaseToggled(this.value);

  @override
  List<Object?> get props => [value];
}

final class GeneratorNumbersToggled extends GeneratorEvent {
  final bool value;
  const GeneratorNumbersToggled(this.value);

  @override
  List<Object?> get props => [value];
}

final class GeneratorSymbolsToggled extends GeneratorEvent {
  final bool value;
  const GeneratorSymbolsToggled(this.value);

  @override
  List<Object?> get props => [value];
}

final class GeneratorExcludeAmbiguousToggled extends GeneratorEvent {
  final bool value;
  const GeneratorExcludeAmbiguousToggled(this.value);

  @override
  List<Object?> get props => [value];
}

final class GeneratorStrategySelected extends GeneratorEvent {
  final String strategyId;
  const GeneratorStrategySelected(this.strategyId);

  @override
  List<Object?> get props => [strategyId];
}
