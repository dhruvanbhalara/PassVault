import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passvault/core/design_system/theme/app_animations.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';

/// A standardized container for grouping related content (Card).
///
/// Features:
/// - Interactive "squish" scale animation.
/// - Haptic feedback on tap.
/// - Shadowless AMOLED support (automatic stroke fallback).
/// - Shadowless AMOLED support (automatic stroke fallback).
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

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
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

    final isShadowless = theme.cardShadow.color == Colors.transparent;
    final cardBody = DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.surface,
        borderRadius: borderRadius,
        boxShadow: isShadowless ? null : [theme.cardShadow],
        border: Border.all(color: theme.cardBorder),
      ),
      child: materialInner,
    );

    return AnimatedScale(
      scale: _isPressed ? theme.cardPressedScale : 1.0,
      duration: AppDuration.fast,
      curve: AppCurves.standard,
      child: Container(margin: widget.margin, child: cardBody),
    );
  }
}
