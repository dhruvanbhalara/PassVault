import 'package:flutter/material.dart';

/// A wrapper widget that rotates its child based on a boolean state.
///
/// Useful for FAB icons that transition between states (e.g. add → close).
/// Uses [AnimatedRotation] for smooth, implicit animation.
///
/// Example:
/// ```dart
/// AppFabRotate(
///   isRotated: isExpanded,
///   angle: 45, // Plus icon → X transition
///   child: Icon(LucideIcons.plus),
/// )
/// ```
class AppFabRotate extends StatelessWidget {
  /// The child widget to rotate.
  final Widget child;

  /// Whether the child should be in the rotated state.
  final bool isRotated;

  /// The rotation angle in degrees. Defaults to 90°.
  final double angle;

  /// The animation duration. Defaults to 200ms.
  final Duration duration;

  /// The animation curve. Defaults to [Curves.easeInOut].
  final Curve curve;

  const AppFabRotate({
    super.key,
    required this.child,
    required this.isRotated,
    this.angle = 90,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    // AnimatedRotation uses turns (1 turn = 360°), so convert degrees.
    final turns = isRotated ? angle / 360 : 0.0;

    return AnimatedRotation(
      turns: turns,
      duration: duration,
      curve: curve,
      child: child,
    );
  }
}
