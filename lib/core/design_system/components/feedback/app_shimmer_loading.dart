import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

/// A shimmer loading placeholder for async content.
///
/// Provides a theme-aware shimmer effect for loading states without external
/// dependencies. Includes accessibility support with loading announcements.
///
/// Example:
/// ```dart
/// AppShimmerLoading(
///   width: 200,
///   height: 20,
///   borderRadius: AppRadius.s,
/// )
/// ```
class AppShimmerLoading extends StatefulWidget {
  /// The width of the shimmer placeholder.
  final double width;

  /// The height of the shimmer placeholder.
  final double height;

  /// The border radius (default: AppRadius.s).
  final double borderRadius;

  /// The shape of the placeholder (default: rectangle).
  final AppShimmerShape shape;

  const AppShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppRadius.s,
    this.shape = AppShimmerShape.rectangle,
  });

  @override
  State<AppShimmerLoading> createState() => _AppShimmerLoadingState();
}

class _AppShimmerLoadingState extends State<AppShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final baseColor = theme.surfaceDim;
    final highlightColor = theme.surface;

    return Semantics(
      liveRegion: true,
      label: context.l10n.loading,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: widget.shape == AppShimmerShape.circle
                  ? null
                  : BorderRadius.circular(widget.borderRadius),
              shape: widget.shape == AppShimmerShape.circle
                  ? BoxShape.circle
                  : BoxShape.rectangle,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [baseColor, highlightColor, baseColor],
                stops: [0.0, _animation.value, 1.0],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Shape variants for shimmer loading placeholders.
enum AppShimmerShape {
  /// Rectangular shape with border radius.
  rectangle,

  /// Circular shape.
  circle,
}
