import 'package:flutter/material.dart';

class DesignSystem {
  // ─────────────────────────────────────────────────────────────
  // Spacing / Layout
  // ─────────────────────────────────────────────────────────────
  static const double spacingZero = 0.0;
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // ─────────────────────────────────────────────────────────────
  // Border Radius
  // ─────────────────────────────────────────────────────────────
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  static BorderRadius get borderRadiusS => BorderRadius.circular(radiusS);
  static BorderRadius get borderRadiusM => BorderRadius.circular(radiusM);
  static BorderRadius get borderRadiusL => BorderRadius.circular(radiusL);
  static BorderRadius get borderRadiusXL => BorderRadius.circular(radiusXL);

  // ─────────────────────────────────────────────────────────────
  // Common Paddings
  // ─────────────────────────────────────────────────────────────
  static const EdgeInsets paddingAllM = EdgeInsets.all(spacingM);
  static const EdgeInsets paddingPage = EdgeInsets.symmetric(
    horizontal: spacingM,
    vertical: spacingM,
  );
}
