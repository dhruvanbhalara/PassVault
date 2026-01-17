import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/l10n/app_localizations.dart';

/// Custom theme extension to expose semantic colors, styles and effects
/// tailored for a secure password manager.
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
    required this.surfaceHighlight,
    required this.securitySurface,
    required this.strengthWeak,
    required this.strengthFair,
    required this.strengthGood,
    required this.strengthStrong,
    required this.outline,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.cardShadow,
    required this.glassBlur,
    required this.glassOpacity,
    required this.passwordText,
    required this.bodyRelaxed,
    required this.vaultGradient, // NEW: Standardized secure surface gradient
    required this.onVaultGradient, // NEW: Foreground color for text on vaultGradient
    required this.inputFocusedBorder, // NEW: Semantic component token
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

  final Color surfaceDim;
  final Color surfaceHighlight;
  final Color securitySurface;
  final Color strengthWeak;
  final Color strengthFair;
  final Color strengthGood;
  final Color strengthStrong;
  final Color outline;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  final BoxShadow cardShadow;
  final double glassBlur;
  final double glassOpacity;

  /// Monospaced style for clear, unambiguous password reading.
  ///
  /// Optimized for semantic dynamic scaling.
  final TextStyle passwordText;

  final TextStyle bodyRelaxed;

  /// Secure surface gradient for high-priority cards and headers.
  final LinearGradient vaultGradient;

  /// Foreground color for text and icons displayed over vaultGradient.
  final Color onVaultGradient;

  /// Specialized color for focused input states.
  final Color inputFocusedBorder;

  @override
  AppThemeExtension copyWith({
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
    Color? surfaceHighlight,
    Color? securitySurface,
    Color? strengthWeak,
    Color? strengthFair,
    Color? strengthGood,
    Color? strengthStrong,
    Color? outline,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    BoxShadow? cardShadow,
    double? glassBlur,
    double? glassOpacity,
    TextStyle? passwordText,
    TextStyle? bodyRelaxed,
    LinearGradient? vaultGradient,
    Color? onVaultGradient,
    Color? inputFocusedBorder,
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
      surfaceHighlight: surfaceHighlight ?? this.surfaceHighlight,
      securitySurface: securitySurface ?? this.securitySurface,
      strengthWeak: strengthWeak ?? this.strengthWeak,
      strengthFair: strengthFair ?? this.strengthFair,
      strengthGood: strengthGood ?? this.strengthGood,
      strengthStrong: strengthStrong ?? this.strengthStrong,
      outline: outline ?? this.outline,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      cardShadow: cardShadow ?? this.cardShadow,
      glassBlur: glassBlur ?? this.glassBlur,
      glassOpacity: glassOpacity ?? this.glassOpacity,
      passwordText: passwordText ?? this.passwordText,
      bodyRelaxed: bodyRelaxed ?? this.bodyRelaxed,
      vaultGradient: vaultGradient ?? this.vaultGradient,
      onVaultGradient: onVaultGradient ?? this.onVaultGradient,
      inputFocusedBorder: inputFocusedBorder ?? this.inputFocusedBorder,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
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
      surfaceHighlight: Color.lerp(
        surfaceHighlight,
        other.surfaceHighlight,
        t,
      )!,
      securitySurface: Color.lerp(securitySurface, other.securitySurface, t)!,
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
      cardShadow: BoxShadow.lerp(cardShadow, other.cardShadow, t)!,
      glassBlur: lerpDouble(glassBlur, other.glassBlur, t)!,
      glassOpacity: lerpDouble(glassOpacity, other.glassOpacity, t)!,
      passwordText: TextStyle.lerp(passwordText, other.passwordText, t)!,
      bodyRelaxed: TextStyle.lerp(bodyRelaxed, other.bodyRelaxed, t)!,
      vaultGradient: LinearGradient.lerp(
        vaultGradient,
        other.vaultGradient,
        t,
      )!,
      onVaultGradient: Color.lerp(onVaultGradient, other.onVaultGradient, t)!,
      inputFocusedBorder: Color.lerp(
        inputFocusedBorder,
        other.inputFocusedBorder,
        t,
      )!,
    );
  }
}

extension AppThemeExtensionContext on BuildContext {
  AppThemeExtension get theme => Theme.of(this).extension<AppThemeExtension>()!;
  AppThemeExtension get colors => theme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get typography => Theme.of(this).textTheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Shortcut for accessing the current localizations.
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Returns whether the current device is considered a mobile/handheld device.
  bool get isMobile => MediaQuery.sizeOf(this).width < AppBreakpoints.mobile;

  /// Returns whether the current device is considered a tablet.
  bool get isTablet =>
      MediaQuery.sizeOf(this).width >= AppBreakpoints.mobile &&
      MediaQuery.sizeOf(this).width < AppBreakpoints.tablet;

  /// Returns whether the current device is considered a desktop.
  bool get isDesktop => MediaQuery.sizeOf(this).width >= AppBreakpoints.tablet;

  /// Responsive value helper that selects a value based on the current breakpoint.
  T responsive<T>(T mobile, {T? tablet, T? desktop}) {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= AppBreakpoints.tablet) return desktop ?? tablet ?? mobile;
    if (width >= AppBreakpoints.mobile) return tablet ?? mobile;
    return mobile;
  }
}
