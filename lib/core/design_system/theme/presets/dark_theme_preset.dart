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
      securitySurface: AppColors.surfaceDark,
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
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
      glassBlur: 20,
      glassOpacity: 0.15,
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
      onVaultGradient: Colors.white,
      inputFocusedBorder: AppColors.getPrimaryFocus(Brightness.dark),
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
