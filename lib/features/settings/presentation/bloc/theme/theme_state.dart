import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';

sealed class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

final class ThemeLoaded extends ThemeState {
  final ThemeType themeType;
  final ThemeMode themeMode;

  const ThemeLoaded({required this.themeType, required this.themeMode});

  @override
  List<Object> get props => [themeType, themeMode];
}
