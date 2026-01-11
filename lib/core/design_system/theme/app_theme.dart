import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_cubit.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_theme_extension.dart';

/// The central theme management class for the PassVault application.
class AppTheme {
  static const String _fontFamily = 'Outfit';
  static const String _monoFontFamily = 'monospace';

  static ThemeData getTheme(ThemeType mode) {
    switch (mode) {
      case ThemeType.system:
        return _lightTheme();
      case ThemeType.light:
        return _lightTheme();
      case ThemeType.dark:
        return _darkTheme();
      case ThemeType.amoled:
        return _amoledTheme();
    }
  }

  static ThemeData get lightTheme => _lightTheme();
  static ThemeData get darkTheme => _darkTheme();
  static ThemeData get amoledTheme => _amoledTheme();

  static ThemeData _lightTheme() {
    final scheme = ColorScheme.fromSeed(
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

    final extension = AppThemeExtension(
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
        colors: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onVaultGradient: Colors.white,
      inputFocusedBorder: AppColors.getPrimaryFocus(Brightness.light),
    );

    return _buildTheme(
      scheme,
      AppColors.bgLight,
      AppColors.surfaceLight,
      false,
      extension,
    );
  }

  static ThemeData _darkTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryLight,
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: const Color(0xFF0F172A),
      secondary: AppColors.secondaryDark,
      onSecondary: const Color(0xFF0F172A),
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textDarkPrimary,
      onSurfaceVariant: AppColors.textDarkSecondary,
      outline: AppColors.borderDark,
      surfaceContainerHighest: AppColors.surfaceDimDark,
    );

    final extension = AppThemeExtension(
      primary: AppColors.primaryDark,
      onPrimary: const Color(0xFF0F172A),
      secondary: AppColors.secondaryDark,
      onSecondary: const Color(0xFF0F172A),
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textDarkPrimary,
      background: AppColors.bgDark,
      error: AppColors.error,
      success: AppColors.success,
      warning: AppColors.warning,
      surfaceDim: AppColors.surfaceDimDark,
      surfaceHighlight: AppColors.primaryDark.withValues(alpha: 0.1),
      securitySurface: AppColors.surfaceDark,
      strengthWeak: AppColors.strengthWeak,
      strengthFair: AppColors.strengthFair,
      strengthGood: AppColors.strengthGood,
      strengthStrong: AppColors.strengthStrong,
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
        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onVaultGradient: Colors.white,
      inputFocusedBorder: AppColors.getPrimaryFocus(Brightness.dark),
    );

    return _buildTheme(
      scheme,
      AppColors.bgDark,
      AppColors.surfaceDark,
      true,
      extension,
    );
  }

  static ThemeData _amoledTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryLight,
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: const Color(0xFF0F172A),
      secondary: AppColors.secondaryDark,
      onSecondary: const Color(0xFF0F172A),
      surface: AppColors.surfaceAmoled,
      onSurface: AppColors.textDarkPrimary,
      onSurfaceVariant: AppColors.textDarkSecondary,
      outline: AppColors.borderDark,
      surfaceContainerHighest: AppColors.surfaceAmoled,
    );

    final extension = AppThemeExtension(
      primary: AppColors.primaryDark,
      onPrimary: const Color(0xFF0F172A),
      secondary: AppColors.secondaryDark,
      onSecondary: const Color(0xFF0F172A),
      surface: AppColors.surfaceAmoled,
      onSurface: AppColors.textDarkPrimary,
      background: AppColors.bgAmoled,
      error: AppColors.error,
      success: AppColors.success,
      warning: AppColors.warning,
      surfaceDim: AppColors.surfaceDimDark,
      surfaceHighlight: AppColors.primaryDark.withValues(alpha: 0.1),
      securitySurface: AppColors.surfaceAmoled,
      strengthWeak: AppColors.strengthWeak,
      strengthFair: AppColors.strengthFair,
      strengthGood: AppColors.strengthGood,
      strengthStrong: AppColors.strengthStrong,
      outline: AppColors.borderDark,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      cardShadow: BoxShadow(
        color: Colors.black.withValues(alpha: 0.5),
        blurRadius: 15,
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
        colors: [Colors.black, Color(0xFF0F172A)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      onVaultGradient: Colors.white,
      inputFocusedBorder: AppColors.getPrimaryFocus(Brightness.dark),
    );

    return _buildTheme(
      scheme,
      AppColors.bgAmoled,
      AppColors.surfaceAmoled,
      true,
      extension,
    );
  }

  static ThemeData _buildTheme(
    ColorScheme scheme,
    Color bg,
    Color surface,
    bool isDark,
    AppThemeExtension extension,
  ) {
    final textPrimary = isDark
        ? AppColors.textDarkPrimary
        : AppColors.textLightPrimary;
    final textSecondary = isDark
        ? AppColors.textDarkSecondary
        : AppColors.textLightSecondary;

    final baseTextTheme = Typography.material2021().black.apply(
      fontFamily: _fontFamily,
      displayColor: textPrimary,
      bodyColor: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      extensions: [extension],
      textTheme: baseTextTheme.copyWith(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
        bodySmall: TextStyle(color: textSecondary, fontSize: 12),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: TextStyle(color: textSecondary),
        hintStyle: TextStyle(color: textSecondary.withValues(alpha: 0.5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(color: extension.inputFocusedBorder, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.m,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.m),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.m,
            horizontal: AppSpacing.l,
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline.withValues(alpha: 0.1),
        thickness: 1,
      ),
    );
  }
}
