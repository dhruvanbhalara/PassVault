import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';

/// A secondary button used for less prominent actions.
///
/// Wraps [TextButton] with standardized styling.
class AppTextButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;

  /// The callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Custom text style override (use sparingly).
  final TextStyle? style;

  /// Standardized text button.
  const AppTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: theme.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.s,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.s),
        ),
      ),
      child: Text(
        text,
        style:
            style ??
            context.typography.labelLarge?.copyWith(
              color: theme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
