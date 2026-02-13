import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_theme_builder.dart';
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
      AppColors.surfaceAmoled,
      true,
      AmoledThemePreset.extension,
      isAmoled: true,
    );
  }

  static ThemeData _buildTheme(
    ColorScheme scheme,
    Color bg,
    Color surface,
    bool isDark,
    AppThemeExtension extension, {
    bool isAmoled = false,
  }) {
    final textPrimary = isDark
        ? AppColors.textDarkPrimary
        : AppColors.textLightPrimary;
    final textSecondary = isDark
        ? AppColors.textDarkSecondary
        : AppColors.textLightSecondary;
    final inputBorderColor = isAmoled
        ? Colors.white24
        : scheme.outline.withValues(alpha: isDark ? 0.62 : 0.58);
    final inputDisabledBorderColor = isAmoled
        ? Colors.white24.withValues(alpha: 0.45)
        : scheme.outline.withValues(alpha: isDark ? 0.40 : 0.36);

    final textTheme = const AppTextThemeBuilder(
      _fontFamily,
    ).build(textPrimary, textSecondary);

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      extensions: [extension],
      textTheme: textTheme,
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
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (BuildContext context) =>
            const Icon(LucideIcons.chevronLeft),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          side: BorderSide(
            color: isAmoled
                ? Colors.white.withValues(alpha: 0.1)
                : scheme.outline.withValues(alpha: 0.1),
          ),
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
          borderSide: BorderSide(color: inputBorderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(color: inputBorderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(color: extension.inputFocusedBorder, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(color: inputDisabledBorderColor, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(color: scheme.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(color: scheme.error, width: 2),
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
