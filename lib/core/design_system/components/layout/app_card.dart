import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passvault/core/design_system/theme/app_animations.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';

/// Defines the visual variants for [AppCard].
enum AppCardVariant {
  /// Elevated style with a shadow (best for Light mode).
  elevated,

  /// Premium glassmorphic vault styling with blur and gradient.
  glass,
}

/// A standardized container for grouping related content (Card).
///
/// Features:
/// - Interactive "squish" scale animation.
/// - Haptic feedback on tap.
/// - Shadowless AMOLED support (automatic stroke fallback).
/// - Glassmorphic support.
class AppCard extends StatefulWidget {
  /// The content of the card.
  final Widget child;

  /// Custom padding override. Defaults to [AppSpacing.m].
  final EdgeInsetsGeometry? padding;

  /// Custom margin override. Defaults to zero.
  final EdgeInsetsGeometry? margin;

  /// The click handler. If provided, adds an [InkWell] splash effect and scale animation.
  final VoidCallback? onTap;

  /// The background color override.
  final Color? backgroundColor;

  /// The visual variant of the card. Defaults to [AppCardVariant.elevated].
  final AppCardVariant variant;

  /// Whether to apply the premium glassmorphic vault styling.
  final bool isVaultStyle;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.variant = AppCardVariant.elevated,
    this.isVaultStyle = false,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isPressed = false;

  void _handleTap() {
    if (widget.onTap != null) {
      HapticFeedback.lightImpact();
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final borderRadius = BorderRadius.circular(AppRadius.l);
    final effectiveVariant = widget.isVaultStyle
        ? AppCardVariant.glass
        : widget.variant;

    final content = Padding(
      padding: widget.padding ?? const EdgeInsets.all(AppSpacing.m),
      child: widget.child,
    );

    final materialInner = Material(
      color: Colors.transparent,
      child: widget.onTap != null
          ? InkWell(
              onTap: _handleTap,
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              borderRadius: borderRadius,
              child: content,
            )
          : content,
    );

    Widget cardBody;

    if (effectiveVariant == AppCardVariant.glass) {
      cardBody = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: theme.glassBlur,
            sigmaY: theme.glassBlur,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.surface.withValues(alpha: theme.glassOpacity),
              borderRadius: borderRadius,
              border: Border.all(color: theme.cardBorder),
            ),
            child: materialInner,
          ),
        ),
      );
    } else {
      final isShadowless = theme.cardShadow.color == Colors.transparent;
      cardBody = DecoratedBox(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? theme.surface,
          borderRadius: borderRadius,
          boxShadow: isShadowless ? null : [theme.cardShadow],
          border: (isShadowless || context.isDarkMode)
              ? Border.all(color: theme.cardBorder)
              : null,
        ),
        child: materialInner,
      );
    }

    return AnimatedScale(
      scale: _isPressed ? theme.cardPressedScale : 1.0,
      duration: AppDuration.fast,
      curve: AppCurves.standard,
      child: Container(margin: widget.margin, child: cardBody),
    );
  }
}
