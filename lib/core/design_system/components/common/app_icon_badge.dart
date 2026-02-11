import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

/// A reusable icon badge component with colored background.
///
/// Consolidates the icon badge pattern seen in `_PickerIcon`, `SettingsMetricIcon`,
/// and similar components. Provides consistent styling using design tokens and
/// includes accessibility support.
///
/// Example:
/// ```dart
/// AppIconBadge(
///   icon: LucideIcons.shield,
///   color: Colors.green,
///   size: AppIconBadgeSize.medium,
/// )
/// ```
class AppIconBadge extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// The color for the icon and background tint.
  final Color color;

  /// The size variant of the badge.
  final AppIconBadgeSize size;

  /// Optional semantic label for the icon.
  final String? semanticLabel;

  const AppIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = AppIconBadgeSize.medium,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final dimensions = size._getDimensions();

    return Semantics(
      image: true,
      label: semanticLabel ?? 'Icon',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(dimensions.padding),
          child: Icon(icon, color: color, size: dimensions.iconSize),
        ),
      ),
    );
  }
}

/// Size variants for AppIconBadge.
enum AppIconBadgeSize {
  /// Small badge (8px padding, 16px icon, 8px radius).
  small,

  /// Medium badge (8px padding, 20px icon, 12px radius).
  medium,

  /// Large badge (12px padding, 24px icon, 16px radius).
  large,

  /// Extra large badge (16px padding, 30px icon, 16px radius).
  extraLarge;

  _AppIconBadgeDimensions _getDimensions() {
    switch (this) {
      case AppIconBadgeSize.small:
        return const _AppIconBadgeDimensions(
          padding: AppSpacing.s,
          iconSize: AppIconSize.s,
          borderRadius: AppRadius.s,
        );
      case AppIconBadgeSize.medium:
        return const _AppIconBadgeDimensions(
          padding: AppSpacing.s,
          iconSize: AppIconSize.m,
          borderRadius: AppRadius.m,
        );
      case AppIconBadgeSize.large:
        return const _AppIconBadgeDimensions(
          padding: AppSpacing.m,
          iconSize: AppIconSize.l,
          borderRadius: AppRadius.l,
        );
      case AppIconBadgeSize.extraLarge:
        return const _AppIconBadgeDimensions(
          padding: AppSpacing.m,
          iconSize: AppIconSize.xl,
          borderRadius: AppRadius.l,
        );
    }
  }
}

/// Internal dimensions for badge variants.
class _AppIconBadgeDimensions {
  final double padding;
  final double iconSize;
  final double borderRadius;

  const _AppIconBadgeDimensions({
    required this.padding,
    required this.iconSize,
    required this.borderRadius,
  });
}
