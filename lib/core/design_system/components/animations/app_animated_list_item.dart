import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

/// A standardized animated wrapper for list items with staggered entrance.
///
/// Provides consistent fade-in and slide-up animations for list items without
/// relying on third-party packages. Uses design system animation tokens for
/// timing and curves.
///
/// Example:
/// ```dart
/// ListView.builder(
///   itemBuilder: (context, index) => AppAnimatedListItem(
///     index: index,
///     child: PasswordListTile(entry: passwords[index]),
///   ),
/// )
/// ```
class AppAnimatedListItem extends StatefulWidget {
  /// The index of this item in the list (used for stagger calculation).
  final int index;

  /// The child widget to animate.
  final Widget child;

  /// The base delay before animation starts (default: 0ms).
  final Duration baseDelay;

  /// The delay increment per index (default: 50ms).
  final Duration delayPerIndex;

  const AppAnimatedListItem({
    super.key,
    required this.index,
    required this.child,
    this.baseDelay = Duration.zero,
    this.delayPerIndex = const Duration(milliseconds: 50),
  });

  @override
  State<AppAnimatedListItem> createState() => _AppAnimatedListItemState();
}

class _AppAnimatedListItemState extends State<AppAnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: AppDuration.normal,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppCurves.emphasizeEntrance),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: AppCurves.emphasizeEntrance,
          ),
        );

    // Calculate staggered delay
    final delay =
        widget.baseDelay +
        Duration(
          milliseconds: widget.delayPerIndex.inMilliseconds * widget.index,
        );

    // Start animation after delay
    _timer = Timer(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(position: _slideAnimation, child: widget.child),
      ),
    );
  }
}
