import 'package:flutter/material.dart';

/// Standardized animation durations and curves for PassVault.
///
/// Ensures a consistent motion feel across the entire application.
abstract class AppDuration {
  /// Fast duration (150ms), for simple transitions like hover or toggle.
  static const Duration fast = Duration(milliseconds: 150);

  /// Normal duration (300ms), the default for page transitions or state changes.
  static const Duration normal = Duration(milliseconds: 300);

  /// Slow duration (500ms), for complex or multi-step animations.
  static const Duration slow = Duration(milliseconds: 500);
}

/// Standardized curves for consistent and fluid motion.
abstract class AppCurves {
  /// Standard easing curve for most animations.
  static const Curve standard = Curves.easeInOutCubic;

  /// Deceleration curve for entering elements.
  static const Curve emphasizeEntrance = Curves.easeOutCubic;

  /// Acceleration curve for exiting elements.
  static const Curve emphasizeExit = Curves.easeInCubic;
}
