import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';

/// A primary button used for main actions in the application.
///
/// Wraps [ElevatedButton] with standardized styling, loading state,
/// and responsive sizing.
class AppButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;

  /// The callback when the button is pressed.
  ///
  /// If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// Whether the button is currently in a loading state.
  ///
  /// When true, a [CircularProgressIndicator] is shown instead of text/icon,
  /// and the button is disabled.
  final bool isLoading;

  /// An optional icon to display before the text.
  final IconData? icon;

  /// Whether the button should take up the full available width.
  final bool isFullWidth;

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
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? theme.primary,
      foregroundColor: foregroundColor ?? theme.onPrimary,
      disabledBackgroundColor: theme.primary.withValues(alpha: 0.5),
      disabledForegroundColor: theme.onPrimary.withValues(alpha: 0.5),
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

    final content = isLoading
        ? SizedBox(
            height: AppIconSize.m,
            width: AppIconSize.m,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ?? theme.onPrimary,
              ),
            ),
          )
        : Row(
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

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: content,
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
