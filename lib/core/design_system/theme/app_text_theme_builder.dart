import 'package:flutter/material.dart';

class AppTextThemeBuilder {
  final String fontFamily;

  const AppTextThemeBuilder(this.fontFamily);

  TextTheme build(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.25,
        color: primary,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0,
        color: primary,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0,
        color: primary,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0,
        color: primary,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0,
        color: primary,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0,
        color: primary,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0,
        color: primary,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.15,
        color: primary,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.1,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.25,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.25,
        color: secondary,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.4,
        color: secondary,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
        color: primary,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.5,
        color: primary,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.5,
        color: secondary,
      ),
    );
  }
}
