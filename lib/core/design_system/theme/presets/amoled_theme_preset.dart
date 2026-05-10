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
      strengthVeryWeak: AppColors.strengthVeryWeak,
      strengthWeak: AppColors.strengthWeak,
      strengthFair: AppColors.strengthFair,
      strengthGood: AppColors.strengthGood,
      strengthStrong: AppColors.strengthStrong,
      strengthVeryStrong: AppColors.strengthVeryStrong,
      outline: AppColors.borderAmoled,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      cardShadow: BoxShadow(
        color: AppColors.white.withValues(alpha: 0.05),
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
        colors: [
          AppColors.vaultGradientDarkStart,
          AppColors.vaultGradientDarkEnd,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onVaultGradient: AppColors.white,
      inputFocusedBorder: AppColors.getPrimaryFocus(Brightness.dark),
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
