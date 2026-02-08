import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_theme_extension.dart';
import 'presets/amoled_theme_preset.dart';
import 'presets/dark_theme_preset.dart';
import 'presets/light_theme_preset.dart';

/// The central theme management class for the PassVault application.
class AppTheme {
  static const String _fontFamily = 'Outfit';

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
    return _buildTheme(
      LightThemePreset.colorScheme,
      AppColors.bgLight,
      AppColors.surfaceLight,
      false,
      LightThemePreset.extension,
    );
  }

  static ThemeData _darkTheme() {
    return _buildTheme(
      DarkThemePreset.colorScheme,
      AppColors.bgDark,
      AppColors.surfaceDark,
      true,
      DarkThemePreset.extension,
    );
  }

  static ThemeData _amoledTheme() {
    return _buildTheme(
      AmoledThemePreset.colorScheme,
      AppColors.bgAmoled,
      AppColors.bgAmoled,
      true,
      AmoledThemePreset.extension,
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
        surfaceTintColor: Colors.transparent,
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
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
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
          return scheme.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return scheme.outline;
        }),
      ),
    );
  }
}
