import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';

enum AppButtonVariant { primary, outlined }

/// A primary button used for main actions in the application.
///
/// Wraps [ElevatedButton] with standardized styling, loading state,
/// and responsive sizing.
class AppButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;

  /// The callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently in a loading state.
  final bool isLoading;

  /// An optional icon to display before the text.
  final IconData? icon;

  /// Whether the button should take up the full available width.
  final bool isFullWidth;

  /// The variant of the button (primary or outlined).
  final AppButtonVariant variant;

  /// Whether to show a glow effect (mandatory for some AMOLED designs).
  final bool hasGlow;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional foreground (text/icon) color override.
  final Color? foregroundColor;

  /// Standardized primary button.
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.variant = AppButtonVariant.primary,
    this.hasGlow = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final child = _ButtonContent(
      isLoading: isLoading,
      text: text,
      icon: icon,
      foregroundColor: foregroundColor,
      isOutlined: variant == AppButtonVariant.outlined,
    );

    Widget button;
    if (variant == AppButtonVariant.outlined) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getOutlinedButtonStyle(context, theme),
        child: child,
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getElevatedButtonStyle(context, theme),
        child: child,
      );
    }

    if (hasGlow &&
        variant == AppButtonVariant.primary &&
        theme.primaryGlow != null) {
      button = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.m),
          boxShadow: [theme.primaryGlow!],
        ),
        child: button,
      );
    }

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  ButtonStyle _getElevatedButtonStyle(
    BuildContext context,
    AppThemeExtension theme,
  ) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? theme.primary,
      foregroundColor: foregroundColor ?? theme.onPrimary,
      disabledBackgroundColor: theme.primary.withValues(alpha: 0.5),
      disabledForegroundColor: theme.onPrimary.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.m,
        horizontal: AppSpacing.l,
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      textStyle: context.typography.labelLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  ButtonStyle _getOutlinedButtonStyle(
    BuildContext context,
    AppThemeExtension theme,
  ) {
    final color = backgroundColor ?? theme.primary;
    return OutlinedButton.styleFrom(
      foregroundColor: color,
      side: BorderSide(color: color, width: 1.5),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.m,
        horizontal: AppSpacing.l,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      textStyle: context.typography.labelLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final bool isLoading;
  final String text;
  final IconData? icon;
  final Color? foregroundColor;
  final bool isOutlined;

  const _ButtonContent({
    required this.isLoading,
    required this.text,
    this.icon,
    this.foregroundColor,
    required this.isOutlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final color =
        foregroundColor ?? (isOutlined ? theme.primary : theme.onPrimary);

    if (isLoading) {
      return SizedBox(
        height: AppIconSize.m,
        width: AppIconSize.m,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: AppIconSize.s),
          const SizedBox(width: AppSpacing.s),
        ],
        Text(text),
      ],
    );
  }
}
