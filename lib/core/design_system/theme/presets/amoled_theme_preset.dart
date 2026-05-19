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
      strengthVeryWeak: AppColors.strengthVeryWeak,
      strengthWeak: AppColors.strengthWeak,
      strengthFair: AppColors.strengthFair,
      strengthGood: AppColors.strengthGood,
      strengthStrong: AppColors.strengthStrong,
      strengthVeryStrong: AppColors.strengthVeryStrong,
      outline: AppColors.borderAmoled,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      cardShadow: const BoxShadow(
        color: AppColors.transparent,
      ), // Shadowless AMOLED
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
        colors: [
          AppColors.primaryAmoled,
          AppColors
              .secondaryDark, // Using secondary dark for a deep emerald feel
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      inputFocusedBorder: AppColors.getPrimaryFocus(Brightness.dark),
      cardBorder: AppColors.white.withValues(
        alpha: 0.12,
      ), // Defined stroke for AMOLED
      inputBorder: AppColors.white.withValues(alpha: 0.24),
      inputDisabledBorder: AppColors.white.withValues(alpha: 0.11),
      chipSelectedBackground: AppColors.primaryAmoled,
      chipUnselectedBackground: AppColors.bgAmoled,
      chipSelectedText: AppColors.bgAmoled,
      chipUnselectedText: AppColors.textDarkPrimary,
      chipBorder: AppColors.textDarkPrimary.withValues(alpha: 0.5),
      radioCardSelectedBorder: AppColors.primaryAmoled,
      radioCardUnselectedBorder: AppColors.borderAmoled,
      bottomNavInactiveIcon: AppColors.textDarkPrimary.withValues(alpha: 0.8),
      logoBackground: AppColors.transparent,
      logoBorder: AppColors.primaryAmoled,
      logoShadow: BoxShadow(
        color: AppColors.primaryAmoled.withValues(alpha: 0.4),
        blurRadius: 16,
        spreadRadius: 2,
      ),
      radioCardSelectedShadow: BoxShadow(
        color: AppColors.primaryAmoled.withValues(alpha: 0.35),
        blurRadius: 12,
        spreadRadius: 1,
      ),
      cardPressedScale: 0.97,
      navIndicatorShadow: BoxShadow(
        color: AppColors.primaryAmoled.withValues(alpha: 0.4),
        blurRadius: 16,
        spreadRadius: 2,
      ),
      focusGlow: BoxShadow(
        color: AppColors.primaryAmoled.withValues(alpha: 0.25),
        blurRadius: 12,
        spreadRadius: 1,
      ),
      buttonGlow: BoxShadow(
        color: AppColors.primaryAmoled.withValues(alpha: 0.3),
        blurRadius: 20,
        spreadRadius: 2,
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
    surfaceDim: AppColors.black,
    surfaceContainerLowest: AppColors.black,
    surfaceContainerLow: AppColors.amoledSurfaceContainerLow,
    surfaceContainer: AppColors.amoledSurfaceContainer,
    surfaceContainerHigh: AppColors.amoledSurfaceContainerHigh,
    surfaceContainerHighest: AppColors.amoledSurfaceContainerHighest,
    onSurfaceVariant: AppColors.textAmoledSecondary,
    outline: AppColors.borderAmoled,
    outlineVariant: AppColors.amoledSurfaceContainerHighest,
  );
}
