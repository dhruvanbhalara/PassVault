/// Standard spacing tokens for padding, margins, and gaps.
abstract class AppSpacing {
  /// 2.0
  static const double xxs = 2.0;

  /// 4.0
  static const double xs = 4.0;

  /// 8.0
  static const double s = 8.0;

  /// 16.0
  static const double m = 16.0;

  /// 24.0
  static const double l = 24.0;

  /// 32.0
  static const double xl = 32.0;

  /// 48.0
  static const double xxl = 48.0;

  /// 64.0
  static const double xxxl = 64.0;

  /// 80.0
  static const double x4xl = 80.0;

  // ─────────────────────────────────────────────────────────────
  // Semantic Layout Tokens
  // ─────────────────────────────────────────────────────────────

  /// Standard vertical safe area (notch) spacing.
  static const double safeAreaVertical = 24.0;

  /// Standard horizontal safe area spacing.
  static const double safeAreaHorizontal = 16.0;

  /// Drag handle width (40.0)
  static const double dragHandleWidth = 40.0;

  /// Drag handle height (4.0)
  static const double dragHandleHeight = 4.0;
}

/// Responsive breakpoints for adaptive layouts.
abstract class AppBreakpoints {
  /// Mobile breakpoint (up to 600px).
  static const double mobile = 600.0;

  /// Tablet breakpoint (up to 1024px).
  static const double tablet = 1024.0;

  /// Desktop breakpoint (1024px and above).
  static const double desktop = 1440.0;
}

/// Standard radius tokens for rounded corners.
abstract class AppRadius {
  /// 2.0
  static const double xxs = 2.0;

  /// 4.0
  static const double xs = 4.0;

  /// 8.0
  static const double s = 8.0;

  /// 12.0
  static const double m = 12.0;

  /// 16.0
  static const double l = 16.0;

  /// 24.0
  static const double xl = 24.0;

  /// Fully rounded (999.0).
  static const double full = 999.0;
}

/// Standard elevation/shadow tokens.
abstract class AppElevation {
  /// No elevation (0.0).
  static const double none = 0.0;

  /// Very light depth (1.0).
  static const double xs = 1.0;

  /// Subtle depth (2.0).
  static const double s = 2.0;

  /// Medium depth (4.0).
  static const double m = 4.0;

  /// Large depth (8.0).
  static const double l = 8.0;

  /// Extra large depth (16.0).
  static const double xl = 16.0;
}

/// Standard icon size tokens.
abstract class AppIconSize {
  /// Extra small (12.0).
  static const double xs = 12.0;

  /// Small (16.0).
  static const double s = 16.0;

  /// Medium (20.0).
  static const double m = 20.0;

  /// Large (24.0).
  static const double l = 24.0;

  /// Extra large (30.0).
  static const double xl = 30.0;

  /// XXL (40.0).
  static const double xxl = 40.0;

  /// XXXL (48.0)
  static const double xxxl = 48.0;
}

/// Helper class providing standardized dimensions and legacy compatibility.
class AppDimensions {
  // ─────────────────────────────────────────────────────────────
  // Semantic Layout Constants
  // ─────────────────────────────────────────────────────────────
  static const double sliverAppBarExpandedHeight = 120.0;
  static const double listTileIconSize = 48.0;
  static const double emptyStateIconSize = 64.0;
  static const double emptyStateIconSizeTablet = 96.0;
  static const double gridAspectRatio = 3.5;
  static const double authAnimationHeight = 180.0;
  static const double authAnimationHeightTablet = 240.0;
  static const double maxContentWidthTablet = 400.0;
  static const double onboardingIconSize = 80.0;
  static const double onboardingIconSizeTablet = 120.0;
  static const double onboardingIconSizeDesktop = 160.0;
  static const double indicatorSize = 8.0;
  static const double indicatorWidthLarge = 24.0;
  static const double passwordStrengthHeight = 6.0;
  static const double sliderTrackHeight = 6.0;
  static const double sliderThumbRadius = 10.0;
  static const double sliderOverlayRadius = 20.0;
  static const double listTileDividerIndent = 72.0;

  // ─────────────────────────────────────────────────────────────
  // Strategy Editor Dimensions
  // ─────────────────────────────────────────────────────────────

  /// Slider track height for strategy editor (premium thick track).
  static const double strategySliderTrackHeight = 12.0;

  /// Slider thumb radius for strategy editor.
  static const double strategySliderThumbRadius = 16.0;

  /// Slider overlay radius for strategy editor.
  static const double strategySliderOverlayRadius = 28.0;

  /// Leading padding for strategy option tiles (aligns with icon).
  static const double strategyTileLeadingPadding = 56.0;

  /// Icon size for strategy option tiles.
  static const double strategyOptionIconSize = 22.0;

  /// Small icon size for strategy list actions.
  static const double strategyIconSmall = 18.0;

  /// Medium icon size for strategy cards.
  static const double strategyIconMedium = 20.0;

  /// FAB bottom padding for scrollable lists.
  static const double fabBottomPadding = 80.0;
}
