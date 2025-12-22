import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_theme_extension.dart';
import 'bloc/theme_cubit.dart';

class AppTheme {
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
      seedColor: AppColors.seed,
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      onSurfaceVariant: AppColors.lightTextSecondary,
      outline: AppColors.lightDivider,
    );

    final extension = AppThemeExtension(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      background: AppColors.lightBackground,
      error: AppColors.error,
      success: AppColors.success,
      warning: AppColors.warning,
      surfaceDim: AppColors.lightTextSecondary.withValues(alpha: 0.1),
      strengthWeak: AppColors.strengthWeak,
      strengthFair: AppColors.strengthFair,
      strengthGood: AppColors.strengthGood,
      strengthStrong: AppColors.strengthStrong,
      outline: AppColors.lightDivider,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
    );

    return _buildTheme(
      scheme,
      AppColors.lightBackground,
      AppColors.lightSurface,
      false,
      extension,
    );
  }

  static ThemeData _darkTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkDivider,
    );

    final extension = AppThemeExtension(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      background: AppColors.darkBackground,
      error: AppColors.error,
      success: AppColors.success,
      warning: AppColors.warning,
      surfaceDim: AppColors.darkTextSecondary.withValues(alpha: 0.1),
      strengthWeak: AppColors.strengthWeak,
      strengthFair: AppColors.strengthFair,
      strengthGood: AppColors.strengthGood,
      strengthStrong: AppColors.strengthStrong,
      outline: AppColors.darkDivider,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
    );

    return _buildTheme(
      scheme,
      AppColors.darkBackground,
      AppColors.darkSurface,
      true,
      extension,
    );
  }

  static ThemeData _amoledTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      surface: AppColors.amoledSurface,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      outline: AppColors.darkDivider,
    );

    final extension = AppThemeExtension(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      surface: AppColors.amoledSurface,
      onSurface: AppColors.darkTextPrimary,
      background: AppColors.amoledBackground,
      error: AppColors.error,
      success: AppColors.success,
      warning: AppColors.warning,
      surfaceDim: AppColors.darkTextSecondary.withValues(alpha: 0.1),
      strengthWeak: AppColors.strengthWeak,
      strengthFair: AppColors.strengthFair,
      strengthGood: AppColors.strengthGood,
      strengthStrong: AppColors.strengthStrong,
      outline: AppColors.darkDivider,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
    );

    return _buildTheme(
      scheme,
      AppColors.amoledBackground,
      AppColors.amoledSurface,
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
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      extensions: [extension],
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
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
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
        bodySmall: TextStyle(color: textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.outfit(
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
          borderRadius: AppDimensions.borderRadiusM,
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: TextStyle(color: textSecondary),
        hintStyle: TextStyle(color: textSecondary.withValues(alpha: 0.5)),
        border: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.borderRadiusM,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceM,
          vertical: AppDimensions.spaceM,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.onPrimary;
          }
          return scheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
          return scheme.onSurfaceVariant.withValues(alpha: 0.1);
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return scheme.onSurfaceVariant;
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.borderRadiusL,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.borderRadiusM,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spaceM,
            horizontal: AppDimensions.spaceL,
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline.withValues(alpha: 0.1),
        thickness: 1,
      ),
    );
  }
}
