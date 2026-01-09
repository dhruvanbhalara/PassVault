import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';

/// A standardized container for grouping related content (Card).
///
/// Applies consistent padding, border radius, background color, and optional
/// shadows/elevation based on the design system.
class AppCard extends StatelessWidget {
  /// The content of the card.
  final Widget child;

  /// Custom padding override. Defaults to [AppSpacing.m].
  final EdgeInsetsGeometry? padding;

  /// Custom margin override. Defaults to zero.
  final EdgeInsetsGeometry? margin;

  /// The click handler. If provided, adds an [InkWell] splash effect.
  final VoidCallback? onTap;

  /// The background color. Defaults to [AppThemeExtension.surface].
  final Color? backgroundColor;

  /// Whether to show a border outline. Defaults to false.
  final bool hasOutline;

  /// Standardized application card/container.
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.hasOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final decoration = BoxDecoration(
      color: backgroundColor ?? theme.surface,
      borderRadius: BorderRadius.circular(AppRadius.l),
      border: hasOutline
          ? Border.all(color: theme.outline.withValues(alpha: 0.1))
          : null,
      boxShadow: [if (!hasOutline) theme.cardShadow],
    );

    final content = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.m),
      child: child,
    );

    return Container(
      margin: margin,
      decoration: decoration,
      clipBehavior:
          Clip.antiAlias, // Ensures splashes don't overflow rounded corners
      child: Material(
        color: Colors.transparent,
        child: onTap != null ? InkWell(onTap: onTap, child: content) : content,
      ),
    );
  }
}
