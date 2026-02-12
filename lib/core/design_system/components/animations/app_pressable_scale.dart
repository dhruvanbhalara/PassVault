import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A wrapper widget that scales its child on press for tactile feedback.
///
/// Provides a consistent "button press" feel across the app by animating
/// scale down on tap-down and back on tap-up/cancel.
///
/// Example:
/// ```dart
/// AppPressableScale(
///   onTap: () => print('tapped'),
///   child: Container(
///     padding: EdgeInsets.all(16),
///     child: Text('Press me'),
///   ),
/// )
/// ```
class AppPressableScale extends StatefulWidget {
  /// The child widget to wrap with scale animation.
  final Widget child;

  /// Callback invoked on a successful tap.
  final VoidCallback? onTap;

  /// The scale factor when pressed. Defaults to 0.95.
  final double scale;

  /// The animation duration. Defaults to 200ms.
  final Duration duration;

  /// The animation curve. Defaults to [Curves.easeInOut].
  final Curve curve;

  /// Whether to trigger light haptic feedback on tap. Defaults to false.
  final bool enableHapticFeedback;

  const AppPressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.95,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.enableHapticFeedback = false,
  });

  @override
  State<AppPressableScale> createState() => _AppPressableScaleState();
}

class _AppPressableScaleState extends State<AppPressableScale> {
  double _currentScale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _currentScale = widget.scale);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _currentScale = 1.0);
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onTap?.call();
  }

  void _onTapCancel() {
    setState(() => _currentScale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _currentScale,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
