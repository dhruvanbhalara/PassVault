import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme_extension.dart';

class AmoledThemePreset {
  static const String _monoFontFamily = 'monospace';

  static AppThemeExtension get extension {
    final scheme = AmoledThemePreset.colorScheme;
    return AppThemeExtension(
      primary: AppColors.primaryDark,
      onPrimary: AppColors.bgDark,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.bgDark,
      surface: AppColors.bgAmoled,
      onSurface: AppColors.textDarkPrimary,
      background: AppColors.bgAmoled,
      error: AppColors.error,
      success: AppColors.success,
      warning: AppColors.warning,
      surfaceDim: AppColors.surfaceAmoled,
      surfaceHighlight: AppColors.primaryDark.withValues(alpha: 0.15),
      securitySurface: AppColors.surfaceAmoled,
      strengthWeak: AppColors.strengthWeak,
      strengthFair: AppColors.strengthFair,
      strengthGood: AppColors.strengthGood,
      strengthStrong: AppColors.strengthStrong,
      outline: AppColors.borderDark,
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
    );
  }

  static ColorScheme get colorScheme => ColorScheme.fromSeed(
    seedColor: AppColors.primaryLight,
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    onPrimary: AppColors.bgDark,
    secondary: AppColors.secondaryDark,
    onSecondary: AppColors.bgDark,
    surface: AppColors.bgAmoled,
    onSurface: AppColors.textDarkPrimary,
    surfaceDim: Colors.black,
    surfaceContainerLowest: Colors.black,
    surfaceContainerLow: AppColors.amoledSurfaceContainerLow,
    surfaceContainer: AppColors.amoledSurfaceContainer,
    surfaceContainerHigh: AppColors.amoledSurfaceContainerHigh,
    surfaceContainerHighest: AppColors.amoledSurfaceContainerHighest,
    onSurfaceVariant: AppColors.textDarkSecondary,
    outline: AppColors.borderDark,
    outlineVariant: AppColors.amoledSurfaceContainerHighest,
  );
}
