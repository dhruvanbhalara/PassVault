import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme_extension.dart';

class LightThemePreset {
  static const String _monoFontFamily = 'monospace';

  static AppThemeExtension get extension {
    final scheme = LightThemePreset.colorScheme;
    return AppThemeExtension(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.white,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textLightPrimary,
      background: AppColors.bgLight,
      error: AppColors.errorLight,
      success: AppColors.successLight,
      warning: AppColors.warning,
      surfaceDim: AppColors.surfaceDimLight,
      surfaceHighlight: AppColors.primaryLight.withValues(alpha: 0.05),
      strengthVeryWeak: AppColors.strengthVeryWeak,
      strengthWeak: AppColors.strengthWeak,
      strengthFair: AppColors.strengthFair,
      strengthGood: AppColors.strengthGood,
      strengthStrong: AppColors.strengthStrong,
      strengthVeryStrong: AppColors.strengthVeryStrong,
      outline: AppColors.borderLight,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      cardShadow: BoxShadow(
        color: AppColors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
      passwordText: const TextStyle(
        fontFamily: _monoFontFamily,
        fontSize: 16,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
      vaultGradient: const LinearGradient(
        colors: [
          AppColors.vaultGradientLightStart,
          AppColors.vaultGradientLightEnd,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onVaultGradient: AppColors.white,
      primaryGradient: const LinearGradient(
        colors: [AppColors.primaryLight, AppColors.secondaryLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      inputFocusedBorder: AppColors.getPrimaryFocus(Brightness.light),
      cardBorder: scheme.outline.withValues(alpha: 0.1),
      inputBorder: scheme.outline.withValues(alpha: 0.58),
      inputDisabledBorder: scheme.outline.withValues(alpha: 0.36),
      chipSelectedBackground: AppColors.primaryLight,
      chipUnselectedBackground: AppColors.white,
      chipSelectedText: AppColors.bgLight,
      chipUnselectedText: AppColors.textLightPrimary,
      chipBorder: AppColors.transparent,
      radioCardSelectedBorder: AppColors.primaryLight,
      radioCardUnselectedBorder: AppColors.borderLight,
      bottomNavInactiveIcon: AppColors.textLightPrimary.withValues(alpha: 0.6),
      logoBackground: AppColors.primaryLight.withValues(alpha: 0.1),
      logoBorder: AppColors.transparent,
      radioCardSelectedShadow: BoxShadow(
        color: AppColors.primaryLight.withValues(alpha: 0.12),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
      cardPressedScale: 0.98,
      navIndicatorShadow: null,
      focusGlow: BoxShadow(
        color: AppColors.primaryLight.withValues(alpha: 0.15),
        blurRadius: 8,
        spreadRadius: 1,
      ),
      buttonGlow: BoxShadow(
        color: AppColors.primaryLight.withValues(alpha: 0.2),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    );
  }

  static ColorScheme get colorScheme => ColorScheme.fromSeed(
    seedColor: AppColors.primaryLight,
    brightness: Brightness.light,
    primary: AppColors.primaryLight,
    onPrimary: AppColors.white,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.white,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textLightPrimary,
    onSurfaceVariant: AppColors.textLightSecondary,
    outline: AppColors.borderLight,
    surfaceContainerHighest: AppColors.surfaceDimLight,
  );
}
