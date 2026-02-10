import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme_extension.dart';

class LightThemePreset {
  static const String _monoFontFamily = 'monospace';

  static AppThemeExtension get extension {
    final scheme = LightThemePreset.colorScheme;
    return AppThemeExtension(
      primary: AppColors.primaryLight,
      onPrimary: Colors.white,
      secondary: AppColors.secondaryLight,
      onSecondary: Colors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textLightPrimary,
      background: AppColors.bgLight,
      error: AppColors.error,
      success: AppColors.success,
      warning: AppColors.warning,
      surfaceDim: AppColors.surfaceDimLight,
      surfaceHighlight: AppColors.primaryLight.withValues(alpha: 0.05),
      securitySurface: AppColors.surfaceDimLight,
      strengthWeak: AppColors.strengthWeak,
      strengthFair: AppColors.strengthFair,
      strengthGood: AppColors.strengthGood,
      strengthStrong: AppColors.strengthStrong,
      outline: AppColors.borderLight,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      cardShadow: BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
      glassBlur: 16,
      glassOpacity: 0.1,
      passwordText: const TextStyle(
        fontFamily: _monoFontFamily,
        fontSize: 16,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
      bodyRelaxed: const TextStyle(height: 1.6, letterSpacing: 0.2),
      vaultGradient: const LinearGradient(
        colors: [
          AppColors.vaultGradientLightStart,
          AppColors.vaultGradientLightEnd,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onVaultGradient: Colors.white,
      inputFocusedBorder: AppColors.getPrimaryFocus(Brightness.light),
    );
  }

  static ColorScheme get colorScheme => ColorScheme.fromSeed(
    seedColor: AppColors.primaryLight,
    brightness: Brightness.light,
    primary: AppColors.primaryLight,
    onPrimary: Colors.white,
    secondary: AppColors.secondaryLight,
    onSecondary: Colors.white,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textLightPrimary,
    onSurfaceVariant: AppColors.textLightSecondary,
    outline: AppColors.borderLight,
    surfaceContainerHighest: AppColors.surfaceDimLight,
  );
}
