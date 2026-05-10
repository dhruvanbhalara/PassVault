import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';

/// A premium branded loading indicator that adapts the pulse animation
/// from the onboarding intro slides.
///
/// Features:
/// - Scaling pulse animation (1.0 to 1.08) as seen in intro slides.
/// - Branded shield icon in a circular themed surface.
/// - Adaptive colors and responsive sizing.
class AppLoader extends StatefulWidget {
  /// The size of the loader (bounding circle).
  final double size;

  /// Custom color override for the icon and pulse background.
  final Color? color;

  const AppLoader({super.key, this.size = 96.0, this.color});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // Pulse duration and curve matching IntroScreen
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final color = widget.color ?? theme.primary;

    return Center(
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.shieldCheck,
            size: widget.size * 0.5, // Branded shield icon
            color: color,
          ),
        ),
      ),
    );
  }
}
