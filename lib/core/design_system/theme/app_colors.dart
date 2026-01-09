import 'package:flutter/material.dart';

/// Raw color palette for the PassVault application.
///
/// These colors are organized to support a secure and efficient user experience.
/// **DO NOT** use these raw colors directly in the UI.
/// Instead, access semantic colors via `context.theme` or `context.colors`
/// provided by [AppThemeExtension].
abstract class AppColors {
  // ─────────────────────────────────────────────────────────────
  // Brand / Core
  // ─────────────────────────────────────────────────────────────
  /// Primary brand color for light theme (Indigo).
  static const Color primaryLight = Color(0xFF3F51B5);

  /// Primary brand color for dark/AMOLED themes (Softer Indigo).
  static const Color primaryDark = Color(0xFF8C9EFF);

  /// Secondary brand color for light theme.
  static const Color secondaryLight = Color(0xFF2CB9B0);

  /// Secondary brand color for dark/AMOLED themes.
  static const Color secondaryDark = Color(0xFF64D8CB);

  // ─────────────────────────────────────────────────────────────
  // Background & Surface (Vault Atmosphere)
  // ─────────────────────────────────────────────────────────────
  /// Main scaffold background for light theme.
  static const Color bgLight = Color(0xFFF8FAFC); // Slate 50

  /// Main scaffold background for dark theme (Slate).
  static const Color bgDark = Color(0xFF0F172A);

  /// Pure black background for AMOLED support.
  static const Color bgAmoled = Colors.black;

  /// Default surface color (cards, sheets) for light theme.
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Default surface color for dark theme.
  static const Color surfaceDark = Color(0xFF1E293B);

  /// Elevated surface color for dark theme (ensures visibility on Slate 900).
  static const Color surfaceElevatedDark = Color(0xFF334155);

  /// Surface color optimized for AMOLED dark mode.
  static const Color surfaceAmoled = Color(0xFF0F172A);

  /// Subdued surface color for light theme.
  static const Color surfaceDimLight = Color(0xFFF1F5F9);

  /// Subdued surface color for dark theme.
  static const Color surfaceDimDark = Color(0xFF334155);

  // ─────────────────────────────────────────────────────────────
  // Text Colors
  // ─────────────────────────────────────────────────────────────
  /// High contrast text for light theme.
  static const Color textLightPrimary = Color(0xFF0F172A);

  /// Subdued / hint text for light theme.
  static const Color textLightSecondary = Color(0xFF64748B);

  /// High contrast text for dark theme.
  static const Color textDarkPrimary = Color(0xFFF8FAFC);

  /// Subdued / hint text for dark theme.
  static const Color textDarkSecondary = Color(0xFF94A3B8);

  // ─────────────────────────────────────────────────────────────
  // Borders & Dividers
  // ─────────────────────────────────────────────────────────────
  /// Standard border/divider color for light theme.
  static const Color borderLight = Color(0xFFE2E8F0);

  /// Standard border/divider color for dark theme.
  static const Color borderDark = Color(0xFF334155);

  // ─────────────────────────────────────────────────────────────
  // Accessibility Helpers
  // ─────────────────────────────────────────────────────────────
  /// Returns a high-contrast variation of the primary color for interactive states.
  static Color getPrimaryFocus(Brightness brightness) {
    return brightness == Brightness.light
        ? const Color(0xFF303F9F) // Indigo 700
        : const Color(0xFFC5CAE9); // Indigo 100
  }

  // ─────────────────────────────────────────────────────────────
  // Security Semantic Colors
  // ─────────────────────────────────────────────────────────────
  /// Color used for critical errors and dangerously weak items.
  static const Color error = Color(0xFFEF4444);

  /// Color used for successful actions and strong security items.
  static const Color success = Color(0xFF10B981);

  /// Color used for warnings and moderate security items.
  static const Color warning = Color(0xFFF59E0B);

  /// Level 1 password strength (Weak).
  static const Color strengthWeak = error;

  /// Level 2 password strength (Fair).
  static const Color strengthFair = Color(0xFFF97316);

  /// Level 3 password strength (Good).
  static const Color strengthGood = warning;

  /// Level 4 password strength (Strong).
  static const Color strengthStrong = success;

  /// Default seed color for theme generation.
  static const Color seed = primaryLight;
}
