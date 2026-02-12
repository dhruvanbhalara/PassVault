import 'package:flutter/material.dart';

/// Raw color palette for the PassVault application.
///
/// These colors are organized to support a secure and efficient user experience.
/// **DO NOT** use these raw colors directly in the UI.
/// Instead, access semantic colors via `context.theme` or `context.colors`
/// provided by [AppThemeExtension].
abstract class AppColors {
  // Brand / Core

  /// Primary brand color for light theme (Blue).
  static const Color primaryLight = Color(0xFF1976D2);

  /// Primary brand color for dark theme (Light Blue).
  static const Color primaryDark = Color(0xFF64B5F6);

  /// Primary brand color for AMOLED theme (Bright Blue).
  static const Color primaryAmoled = Color(0xFF2196F3);

  /// Secondary brand color for light theme (Orange).
  static const Color secondaryLight = Color(0xFFFF6F00);

  /// Secondary brand color for dark theme (Teal).
  static const Color secondaryDark = Color(0xFF26A69A);

  /// Secondary brand color for AMOLED theme (Cyan).
  static const Color secondaryAmoled = Color(0xFF00BCD4);

  // Background & Surface

  /// Main scaffold background for light theme.
  static const Color bgLight = Color(0xFFFFFFFF);

  /// Main scaffold background for dark theme.
  static const Color bgDark = Color(0xFF121212);

  /// Pure black background for AMOLED support (#000000).
  static const Color bgAmoled = Colors.black;

  /// Default surface color (cards, sheets) for light theme.
  static const Color surfaceLight = Color(0xFFF5F5F5);

  /// Default surface color for dark theme.
  static const Color surfaceDark = Color(0xFF1E1E1E);

  /// Elevated surface color for dark theme.
  static const Color surfaceElevatedDark = Color(0xFF2C2C2C);

  /// Surface color optimized for AMOLED dark mode (slightly elevated).
  static const Color surfaceAmoled = Color(0xFF0A0A0A);

  /// Subdued surface color for light theme.
  static const Color surfaceDimLight = Color(0xFFEEEEEE);

  /// Subdued surface color for dark theme.
  static const Color surfaceDimDark = Color(0xFF2C2C2C);

  // Text Colors

  /// High contrast text for light theme.
  static const Color textLightPrimary = Color(0xFF212121);

  /// Subdued / hint text for light theme.
  static const Color textLightSecondary = Color(0xFF757575);

  /// High contrast text for dark / AMOLED themes.
  static const Color textDarkPrimary = Color(0xFFFFFFFF);

  /// Subdued / hint text for dark theme.
  static const Color textDarkSecondary = Color(0xFFB0B0B0);

  /// Subdued / hint text for AMOLED theme (higher contrast).
  static const Color textAmoledSecondary = Color(0xFFCCCCCC);

  // Borders & Dividers

  /// Standard border/divider color for light theme.
  static const Color borderLight = Color(0xFFE0E0E0);

  /// Standard border/divider color for dark theme.
  static const Color borderDark = Color(0xFF333333);

  /// Standard border/divider color for AMOLED theme.
  static const Color borderAmoled = Color(0xFF1A1A1A);

  // Accessibility Helpers

  /// Returns a high-contrast variation of the primary color for interactive states.
  static Color getPrimaryFocus(Brightness brightness) {
    return brightness == Brightness.light
        ? const Color(0xFF1565C0) // Blue 800
        : const Color(0xFF90CAF9); // Blue 200
  }

  // Security Semantic Colors

  /// Error color for light theme.
  static const Color errorLight = Color(0xFFD32F2F);

  /// Error color for dark theme.
  static const Color errorDark = Color(0xFFEF5350);

  /// Error color for AMOLED theme (bright red).
  static const Color errorAmoled = Color(0xFFFF5252);

  /// Success color for light theme.
  static const Color successLight = Color(0xFF388E3C);

  /// Success color for dark theme.
  static const Color successDark = Color(0xFF66BB6A);

  /// Success color for AMOLED theme (neon green).
  static const Color successAmoled = Color(0xFF00E676);

  /// Color used for warnings and moderate security items.
  static const Color warning = Color(0xFFF59E0B);

  /// Level 1 password strength (Weak).
  static const Color strengthWeak = errorLight;

  /// Level 2 password strength (Fair).
  static const Color strengthFair = Color(0xFFF97316);

  /// Level 3 password strength (Good).
  static const Color strengthGood = warning;

  /// Level 4 password strength (Strong).
  static const Color strengthStrong = successLight;

  // Vault Gradient Colors

  /// Light theme vault gradient start color.
  static const Color vaultGradientLightStart = Color(0xFF1976D2);

  /// Light theme vault gradient end color.
  static const Color vaultGradientLightEnd = Color(0xFF1E88E5);

  /// Dark theme vault gradient start color.
  static const Color vaultGradientDarkStart = Color(0xFF1E1E1E);

  /// Dark theme vault gradient end color.
  static const Color vaultGradientDarkEnd = Color(0xFF121212);

  // AMOLED Surface Containers (Neutral Grays)

  /// AMOLED surface container low.
  static const Color amoledSurfaceContainerLow = Color(0xFF121212);

  /// AMOLED surface container medium.
  static const Color amoledSurfaceContainer = Color(0xFF1C1C1C);

  /// AMOLED surface container high.
  static const Color amoledSurfaceContainerHigh = Color(0xFF2C2C2C);

  /// AMOLED surface container highest.
  static const Color amoledSurfaceContainerHighest = Color(0xFF383838);

  /// Default seed color for theme generation.
  static const Color seed = primaryLight;
}
