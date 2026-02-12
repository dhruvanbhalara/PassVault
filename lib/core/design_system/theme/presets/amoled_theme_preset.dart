import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme_extension.dart';

class AmoledThemePreset {
  static const String _monoFontFamily = 'monospace';

  static AppThemeExtension get extension {
    final scheme = AmoledThemePreset.colorScheme;
    return AppThemeExtension(
      primary: AppColors.primaryAmoled,
      onPrimary: AppColors.bgAmoled,
      secondary: AppColors.secondaryAmoled,
      onSecondary: AppColors.bgAmoled,
      surface: AppColors.bgAmoled,
      onSurface: AppColors.textDarkPrimary,
      background: AppColors.bgAmoled,
      error: AppColors.errorAmoled,
      success: AppColors.successAmoled,
      warning: AppColors.warning,
      surfaceDim: AppColors.surfaceAmoled,
      surfaceHighlight: AppColors.primaryAmoled.withValues(alpha: 0.15),
      securitySurface: AppColors.surfaceAmoled,
      strengthWeak: AppColors.strengthWeak,
      strengthFair: AppColors.strengthFair,
      strengthGood: AppColors.strengthGood,
      strengthStrong: AppColors.strengthStrong,
      outline: AppColors.borderAmoled,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      cardShadow: BoxShadow(
        color: Colors.white.withValues(alpha: 0.05),
        blurRadius: 15,
        offset: const Offset(0, 0),
      ),
      glassBlur: 20,
      glassOpacity: 0.2,
      passwordText: const TextStyle(
        fontFamily: _monoFontFamily,
        fontSize: 16,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
      bodyRelaxed: const TextStyle(height: 1.6, letterSpacing: 0.2),
      vaultGradient: const LinearGradient(
        colors: [AppColors.vaultGradientDarkEnd, Colors.black],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onVaultGradient: Colors.white,
      inputFocusedBorder: AppColors.getPrimaryFocus(Brightness.dark),
      // AMOLED glow effects – subtle outer glow for accent elements on
      // pure-black backgrounds.  Blur 12, spread 1, accent at ~40% opacity.
      primaryGlow: BoxShadow(
        color: AppColors.primaryAmoled.withValues(alpha: 0.40),
        blurRadius: 12,
        spreadRadius: 1,
      ),
      secondaryGlow: BoxShadow(
        color: AppColors.secondaryAmoled.withValues(alpha: 0.35),
        blurRadius: 10,
        spreadRadius: 1,
      ),
      errorGlow: BoxShadow(
        color: AppColors.errorAmoled.withValues(alpha: 0.35),
        blurRadius: 10,
        spreadRadius: 1,
      ),
      successGlow: BoxShadow(
        color: AppColors.successAmoled.withValues(alpha: 0.35),
        blurRadius: 10,
        spreadRadius: 1,
      ),
      accentGlow: BoxShadow(
        color: AppColors.primaryAmoled.withValues(alpha: 0.30),
        blurRadius: 8,
        spreadRadius: 0,
      ),
    );
  }

  static ColorScheme get colorScheme => ColorScheme.fromSeed(
    seedColor: AppColors.primaryAmoled,
    brightness: Brightness.dark,
    primary: AppColors.primaryAmoled,
    onPrimary: AppColors.bgAmoled,
    secondary: AppColors.secondaryAmoled,
    onSecondary: AppColors.bgAmoled,
    surface: AppColors.bgAmoled,
    onSurface: AppColors.textDarkPrimary,
    surfaceDim: Colors.black,
    surfaceContainerLowest: Colors.black,
    surfaceContainerLow: AppColors.amoledSurfaceContainerLow,
    surfaceContainer: AppColors.amoledSurfaceContainer,
    surfaceContainerHigh: AppColors.amoledSurfaceContainerHigh,
    surfaceContainerHighest: AppColors.amoledSurfaceContainerHighest,
    onSurfaceVariant: AppColors.textAmoledSecondary,
    outline: AppColors.borderAmoled,
    outlineVariant: AppColors.amoledSurfaceContainerHighest,
  );
}
