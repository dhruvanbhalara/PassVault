import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';

/// A premium interactive primary button component.
///
/// Features:
/// - "Obsidian Emerald" gradient support.
/// - Interactive "squish" scale animation.
/// - Integrated Haptic Feedback.
/// - Shadowless AMOLED support (high contrast borders).
class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;
  final bool isGradient;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.isGradient = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  void _onTap() {
    if (widget.onPressed != null && !widget.isLoading) {
      HapticFeedback.lightImpact();
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    Widget buttonContent = _ButtonContent(
      isLoading: widget.isLoading,
      text: widget.text,
      icon: widget.icon,
      foregroundColor: widget.foregroundColor,
    );

    return AnimatedScale(
      scale: _isPressed ? theme.cardPressedScale : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: _onTap,
        child: _ButtonBackground(
          isGradient: widget.isGradient,
          isFullWidth: widget.isFullWidth,
          backgroundColor: widget.backgroundColor,
          onPressed: widget.onPressed,
          isLoading: widget.isLoading,
          child: buttonContent,
        ),
      ),
    );
  }
}

class _ButtonBackground extends StatelessWidget {
  final bool isGradient;
  final bool isFullWidth;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget child;

  const _ButtonBackground({
    required this.isGradient,
    required this.isFullWidth,
    this.backgroundColor,
    this.onPressed,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDisabled = onPressed == null || isLoading;

    final decoration = _getDecoration(theme, isDisabled);

    return Container(
      width: isFullWidth ? double.infinity : null,
      decoration: decoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.m,
          horizontal: AppSpacing.l,
        ),
        child: child,
      ),
    );
  }

  BoxDecoration _getDecoration(AppThemeExtension theme, bool isDisabled) {
    final borderRadius = BorderRadius.circular(AppRadius.m);
    final baseColor = backgroundColor ?? theme.primary;

    return BoxDecoration(
      borderRadius: borderRadius,
      color: isGradient
          ? null
          : (isDisabled ? baseColor.withValues(alpha: 0.5) : baseColor),
      gradient: isGradient && !isDisabled ? theme.primaryGradient : null,
      boxShadow: !isDisabled && theme.buttonGlow != null
          ? [theme.buttonGlow!]
          : null,
      border: theme.cardShadow.color == Colors.transparent
          ? Border.all(color: theme.primary.withValues(alpha: 0.2))
          : null,
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final bool isLoading;
  final String text;
  final IconData? icon;
  final Color? foregroundColor;

  const _ButtonContent({
    required this.isLoading,
    required this.text,
    this.icon,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textColor = foregroundColor ?? theme.onPrimary;

    if (isLoading) {
      return Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: AppIconSize.s, color: textColor),
          const SizedBox(width: AppSpacing.s),
        ],
        Text(
          text,
          style: context.typography.labelLarge?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
