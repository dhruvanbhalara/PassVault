import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.error,
    required this.success,
    required this.warning,
    required this.surfaceDim,
    required this.strengthWeak,
    required this.strengthFair,
    required this.strengthGood,
    required this.strengthStrong,
    required this.outline,
    required this.primaryContainer,
    required this.onPrimaryContainer,
  });

  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color surface;
  final Color onSurface;
  final Color background;
  final Color error;
  final Color success;
  final Color warning;

  // Custom Semantic Colors
  final Color surfaceDim; // For tracks, placeholders
  final Color strengthWeak;
  final Color strengthFair;
  final Color strengthGood;
  final Color strengthStrong;
  final Color outline;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? surface,
    Color? onSurface,
    Color? background,
    Color? error,
    Color? success,
    Color? warning,
    Color? surfaceDim,
    Color? strengthWeak,
    Color? strengthFair,
    Color? strengthGood,
    Color? strengthStrong,
    Color? outline,
    Color? primaryContainer,
    Color? onPrimaryContainer,
  }) {
    return AppThemeExtension(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      background: background ?? this.background,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      strengthWeak: strengthWeak ?? this.strengthWeak,
      strengthFair: strengthFair ?? this.strengthFair,
      strengthGood: strengthGood ?? this.strengthGood,
      strengthStrong: strengthStrong ?? this.strengthStrong,
      outline: outline ?? this.outline,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      background: Color.lerp(background, other.background, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
      strengthWeak: Color.lerp(strengthWeak, other.strengthWeak, t)!,
      strengthFair: Color.lerp(strengthFair, other.strengthFair, t)!,
      strengthGood: Color.lerp(strengthGood, other.strengthGood, t)!,
      strengthStrong: Color.lerp(strengthStrong, other.strengthStrong, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      onPrimaryContainer: Color.lerp(
        onPrimaryContainer,
        other.onPrimaryContainer,
        t,
      )!,
    );
  }
}

// Extension to access custom theme colors via context
extension AppThemeExtensionContext on BuildContext {
  AppThemeExtension get colors =>
      Theme.of(this).extension<AppThemeExtension>()!;
  TextTheme get typography => Theme.of(this).textTheme;
}
