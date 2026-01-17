import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ThemeType { system, light, dark, amoled }

class ThemeState extends Equatable {
  final ThemeType themeType;
  final ThemeMode themeMode;

  const ThemeState({required this.themeType, required this.themeMode});

  factory ThemeState.initial() => const ThemeState(
    themeType: ThemeType.system,
    themeMode: ThemeMode.system,
  );

  @override
  List<Object> get props => [themeType, themeMode];
}
