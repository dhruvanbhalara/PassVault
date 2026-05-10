import 'dart:ui';
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

  /// Whether to show a glow effect (useful for AMOLED).
  final bool hasGlow;

  /// Whether to apply the premium glassmorphic vault styling.
  final bool isVaultStyle;

  /// Standardized application card/container.
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.hasOutline = false,
    this.hasGlow = false,
    this.isVaultStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final borderRadius = BorderRadius.circular(AppRadius.l);

    final content = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.m),
      child: child,
    );

    final materialInner = Material(
      color: Colors.transparent,
      child: onTap != null ? InkWell(onTap: onTap, child: content) : content,
    );

    if (isVaultStyle) {
      final vaultGradient = theme.vaultGradient;
      final frostedGradient = LinearGradient(
        colors: vaultGradient.colors
            .map((c) => c.withValues(alpha: theme.glassOpacity))
            .toList(),
        stops: vaultGradient.stops,
        begin: vaultGradient.begin,
        end: vaultGradient.end,
        transform: vaultGradient.transform,
      );

      return Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            if (hasGlow && theme.accentGlow != null) theme.accentGlow!,
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: theme.glassBlur,
              sigmaY: theme.glassBlur,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: frostedGradient,
                borderRadius: borderRadius,
                border: Border.all(color: theme.outline.withValues(alpha: 0.2)),
              ),
              child: materialInner,
            ),
          ),
        ),
      );
    }

    // Standard styling
    final decoration = BoxDecoration(
      color: backgroundColor ?? theme.surface,
      borderRadius: borderRadius,
      border: hasOutline
          ? Border.all(color: theme.outline.withValues(alpha: 0.1))
          : null,
      boxShadow: [
        if (!hasOutline) theme.cardShadow,
        if (hasGlow && theme.accentGlow != null) theme.accentGlow!,
      ],
    );

    return Container(
      margin: margin,
      decoration: decoration,
      clipBehavior: Clip.antiAlias,
      child: materialInner,
    );
  }
}
