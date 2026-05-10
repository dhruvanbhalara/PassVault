import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/l10n/app_localizations.dart';

export 'package:passvault/l10n/app_localizations.dart';

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
    required this.strengthVeryWeak,
    required this.strengthWeak,
    required this.strengthFair,
    required this.strengthGood,
    required this.strengthStrong,
    required this.strengthVeryStrong,
    required this.outline,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.cardShadow,
    required this.glassBlur,
    required this.glassOpacity,
    required this.passwordText,
    required this.vaultGradient,
    required this.onVaultGradient,
    required this.primaryGradient,
    required this.inputFocusedBorder,
    required this.cardBorder,
    required this.inputBorder,
    required this.inputDisabledBorder,
    required this.chipSelectedBackground,
    required this.chipUnselectedBackground,
    required this.chipSelectedText,
    required this.chipUnselectedText,
    required this.chipBorder,
    required this.radioCardSelectedBorder,
    required this.radioCardUnselectedBorder,
    required this.bottomNavInactiveIcon,
    required this.logoBackground,
    required this.logoBorder,
    this.logoShadow,
    required this.radioCardSelectedShadow,
    required this.cardPressedScale,
    this.navIndicatorShadow,
    this.focusGlow,
    this.buttonGlow,
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
  final Color strengthVeryWeak;
  final Color strengthWeak;
  final Color strengthFair;
  final Color strengthGood;
  final Color strengthStrong;
  final Color strengthVeryStrong;
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

  /// Secure surface gradient for high-priority cards and headers.
  final LinearGradient vaultGradient;

  /// Foreground color for text and icons displayed over vaultGradient.
  final Color onVaultGradient;

  /// Main brand gradient for primary buttons and high-vibrancy surfaces.
  final LinearGradient primaryGradient;

  /// Specialized color for focused input states.
  final Color inputFocusedBorder;

  final Color cardBorder;
  final Color inputBorder;
  final Color inputDisabledBorder;
  final Color chipSelectedBackground;
  final Color chipUnselectedBackground;
  final Color chipSelectedText;
  final Color chipUnselectedText;
  final Color chipBorder;
  final Color radioCardSelectedBorder;
  final Color radioCardUnselectedBorder;
  final Color bottomNavInactiveIcon;
  final Color logoBackground;
  final Color logoBorder;
  final BoxShadow? logoShadow;
  final BoxShadow radioCardSelectedShadow;
  final double cardPressedScale;
  final BoxShadow? navIndicatorShadow;
  final BoxShadow? focusGlow;
  final BoxShadow? buttonGlow;

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
    Color? strengthVeryWeak,
    Color? strengthWeak,
    Color? strengthFair,
    Color? strengthGood,
    Color? strengthStrong,
    Color? strengthVeryStrong,
    Color? outline,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    BoxShadow? cardShadow,
    double? glassBlur,
    double? glassOpacity,
    TextStyle? passwordText,
    LinearGradient? vaultGradient,
    Color? onVaultGradient,
    LinearGradient? primaryGradient,
    Color? inputFocusedBorder,
    Color? cardBorder,
    Color? inputBorder,
    Color? inputDisabledBorder,
    Color? chipSelectedBackground,
    Color? chipUnselectedBackground,
    Color? chipSelectedText,
    Color? chipUnselectedText,
    Color? chipBorder,
    Color? radioCardSelectedBorder,
    Color? radioCardUnselectedBorder,
    Color? bottomNavInactiveIcon,
    Color? logoBackground,
    Color? logoBorder,
    BoxShadow? logoShadow,
    BoxShadow? radioCardSelectedShadow,
    double? cardPressedScale,
    BoxShadow? navIndicatorShadow,
    BoxShadow? focusGlow,
    BoxShadow? buttonGlow,
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
      strengthVeryWeak: strengthVeryWeak ?? this.strengthVeryWeak,
      strengthWeak: strengthWeak ?? this.strengthWeak,
      strengthFair: strengthFair ?? this.strengthFair,
      strengthGood: strengthGood ?? this.strengthGood,
      strengthStrong: strengthStrong ?? this.strengthStrong,
      strengthVeryStrong: strengthVeryStrong ?? this.strengthVeryStrong,
      outline: outline ?? this.outline,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      cardShadow: cardShadow ?? this.cardShadow,
      glassBlur: glassBlur ?? this.glassBlur,
      glassOpacity: glassOpacity ?? this.glassOpacity,
      passwordText: passwordText ?? this.passwordText,
      vaultGradient: vaultGradient ?? this.vaultGradient,
      onVaultGradient: onVaultGradient ?? this.onVaultGradient,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      inputFocusedBorder: inputFocusedBorder ?? this.inputFocusedBorder,
      cardBorder: cardBorder ?? this.cardBorder,
      inputBorder: inputBorder ?? this.inputBorder,
      inputDisabledBorder: inputDisabledBorder ?? this.inputDisabledBorder,
      chipSelectedBackground:
          chipSelectedBackground ?? this.chipSelectedBackground,
      chipUnselectedBackground:
          chipUnselectedBackground ?? this.chipUnselectedBackground,
      chipSelectedText: chipSelectedText ?? this.chipSelectedText,
      chipUnselectedText: chipUnselectedText ?? this.chipUnselectedText,
      chipBorder: chipBorder ?? this.chipBorder,
      radioCardSelectedBorder:
          radioCardSelectedBorder ?? this.radioCardSelectedBorder,
      radioCardUnselectedBorder:
          radioCardUnselectedBorder ?? this.radioCardUnselectedBorder,
      bottomNavInactiveIcon:
          bottomNavInactiveIcon ?? this.bottomNavInactiveIcon,
      logoBackground: logoBackground ?? this.logoBackground,
      logoBorder: logoBorder ?? this.logoBorder,
      logoShadow: logoShadow ?? this.logoShadow,
      radioCardSelectedShadow:
          radioCardSelectedShadow ?? this.radioCardSelectedShadow,
      cardPressedScale: cardPressedScale ?? this.cardPressedScale,
      navIndicatorShadow: navIndicatorShadow ?? this.navIndicatorShadow,
      focusGlow: focusGlow ?? this.focusGlow,
      buttonGlow: buttonGlow ?? this.buttonGlow,
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
      strengthVeryWeak: Color.lerp(
        strengthVeryWeak,
        other.strengthVeryWeak,
        t,
      )!,
      strengthWeak: Color.lerp(strengthWeak, other.strengthWeak, t)!,
      strengthFair: Color.lerp(strengthFair, other.strengthFair, t)!,
      strengthGood: Color.lerp(strengthGood, other.strengthGood, t)!,
      strengthStrong: Color.lerp(strengthStrong, other.strengthStrong, t)!,
      strengthVeryStrong: Color.lerp(
        strengthVeryStrong,
        other.strengthVeryStrong,
        t,
      )!,
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
      vaultGradient: LinearGradient.lerp(
        vaultGradient,
        other.vaultGradient,
        t,
      )!,
      onVaultGradient: Color.lerp(onVaultGradient, other.onVaultGradient, t)!,
      primaryGradient: LinearGradient.lerp(
        primaryGradient,
        other.primaryGradient,
        t,
      )!,
      inputFocusedBorder: Color.lerp(
        inputFocusedBorder,
        other.inputFocusedBorder,
        t,
      )!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      inputDisabledBorder: Color.lerp(
        inputDisabledBorder,
        other.inputDisabledBorder,
        t,
      )!,
      chipSelectedBackground: Color.lerp(
        chipSelectedBackground,
        other.chipSelectedBackground,
        t,
      )!,
      chipUnselectedBackground: Color.lerp(
        chipUnselectedBackground,
        other.chipUnselectedBackground,
        t,
      )!,
      chipSelectedText: Color.lerp(
        chipSelectedText,
        other.chipSelectedText,
        t,
      )!,
      chipUnselectedText: Color.lerp(
        chipUnselectedText,
        other.chipUnselectedText,
        t,
      )!,
      chipBorder: Color.lerp(chipBorder, other.chipBorder, t)!,
      radioCardSelectedBorder: Color.lerp(
        radioCardSelectedBorder,
        other.radioCardSelectedBorder,
        t,
      )!,
      radioCardUnselectedBorder: Color.lerp(
        radioCardUnselectedBorder,
        other.radioCardUnselectedBorder,
        t,
      )!,
      bottomNavInactiveIcon: Color.lerp(
        bottomNavInactiveIcon,
        other.bottomNavInactiveIcon,
        t,
      )!,
      logoBackground: Color.lerp(logoBackground, other.logoBackground, t)!,
      logoBorder: Color.lerp(logoBorder, other.logoBorder, t)!,
      logoShadow: BoxShadow.lerp(logoShadow, other.logoShadow, t),
      radioCardSelectedShadow: BoxShadow.lerp(
        radioCardSelectedShadow,
        other.radioCardSelectedShadow,
        t,
      )!,
      cardPressedScale: lerpDouble(
        cardPressedScale,
        other.cardPressedScale,
        t,
      )!,
      navIndicatorShadow: BoxShadow.lerp(
        navIndicatorShadow,
        other.navIndicatorShadow,
        t,
      ),
      focusGlow: BoxShadow.lerp(focusGlow, other.focusGlow, t),
      buttonGlow: BoxShadow.lerp(buttonGlow, other.buttonGlow, t),
    );
  }
}

extension AppThemeExtensionContext on BuildContext {
  AppThemeExtension get theme => Theme.of(this).extension<AppThemeExtension>()!;
  AppThemeExtension get colors => theme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get typography => Theme.of(this).textTheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  bool get isAmoled => Theme.of(this).scaffoldBackgroundColor == Colors.black;

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
