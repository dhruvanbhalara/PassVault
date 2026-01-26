import 'package:equatable/equatable.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeInitialized extends ThemeEvent {
  const ThemeInitialized();
}

class ThemeChanged extends ThemeEvent {
  final ThemeType themeType;

  const ThemeChanged(this.themeType);

  @override
  List<Object?> get props => [themeType];
}
