import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme_extension.dart';

class DarkThemePreset {
  static const String _monoFontFamily = 'monospace';

  static AppThemeExtension get extension {
    final scheme = DarkThemePreset.colorScheme;
    return AppThemeExtension(
      primary: AppColors.primaryDark,
      onPrimary: AppColors.bgDark,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.bgDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textDarkPrimary,
      background: AppColors.bgDark,
      error: AppColors.errorDark,
      success: AppColors.successDark,
      warning: AppColors.warning,
      surfaceDim: AppColors.surfaceDimDark,
      surfaceHighlight: AppColors.primaryDark.withValues(alpha: 0.1),
      strengthVeryWeak: AppColors.strengthVeryWeak,
      strengthWeak: AppColors.strengthWeak,
      strengthFair: AppColors.strengthFair,
      strengthGood: AppColors.strengthGood,
      strengthStrong: AppColors.strengthStrong,
      strengthVeryStrong: AppColors.strengthVeryStrong,
      outline: AppColors.borderDark,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      cardShadow: BoxShadow(
        color: AppColors.black.withValues(alpha: 0.3),
        blurRadius: 12,
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
          AppColors.vaultGradientDarkStart,
          AppColors.vaultGradientDarkEnd,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onVaultGradient: AppColors.white,
      primaryGradient: const LinearGradient(
        colors: [AppColors.primaryDark, AppColors.secondaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      inputFocusedBorder: AppColors.getPrimaryFocus(Brightness.dark),
      cardBorder: scheme.outline.withValues(alpha: 0.1),
      inputBorder: scheme.outline.withValues(alpha: 0.62),
      inputDisabledBorder: scheme.outline.withValues(alpha: 0.40),
      chipSelectedBackground: AppColors.secondaryDark,
      chipUnselectedBackground: AppColors.surfaceDimDark,
      chipSelectedText: AppColors.bgDark,
      chipUnselectedText: AppColors.textDarkPrimary,
      chipBorder: AppColors.transparent,
      radioCardSelectedBorder: AppColors.secondaryDark,
      radioCardUnselectedBorder: AppColors.primaryDark.withValues(alpha: 0.1),
      bottomNavInactiveIcon: AppColors.textDarkPrimary.withValues(alpha: 0.6),
      logoBackground: AppColors.primaryDark.withValues(alpha: 0.1),
      logoBorder: AppColors.transparent,
      radioCardSelectedShadow: BoxShadow(
        color: AppColors.primaryDark.withValues(alpha: 0.15),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
      cardPressedScale: 0.98,
      navIndicatorShadow: BoxShadow(
        color: AppColors.primaryDark.withValues(alpha: 0.2),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
      focusGlow: BoxShadow(
        color: AppColors.primaryDark.withValues(alpha: 0.2),
        blurRadius: 10,
        spreadRadius: 2,
      ),
      buttonGlow: BoxShadow(
        color: AppColors.primaryDark.withValues(alpha: 0.25),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    );
  }

  static ColorScheme get colorScheme => ColorScheme.fromSeed(
    seedColor: AppColors.primaryDark,
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    onPrimary: AppColors.bgDark,
    secondary: AppColors.secondaryDark,
    onSecondary: AppColors.bgDark,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textDarkPrimary,
    onSurfaceVariant: AppColors.textDarkSecondary,
    outline: AppColors.borderDark,
    surfaceContainerHighest: AppColors.surfaceDimDark,
  );
}
