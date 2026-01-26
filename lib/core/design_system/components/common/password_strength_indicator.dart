import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

/// A widget for displaying password strength with semantic colors.
class PasswordStrengthIndicator extends StatelessWidget {
  final double strength;
  final bool showLabel;

  const PasswordStrengthIndicator({
    super.key,
    required this.strength,
    this.showLabel = true,
  });

  Color _getStrengthColor(BuildContext context) {
    final theme = context.theme;
    if (strength <= 0.25) return theme.strengthWeak;
    if (strength <= 0.5) return theme.strengthFair;
    if (strength <= 0.75) return theme.strengthGood;
    return theme.strengthStrong;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final color = _getStrengthColor(context);

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xxs),
            child: LinearProgressIndicator(
              value: strength,
              backgroundColor: theme.securitySurface,
              color: color,
              minHeight: AppDimensions.passwordStrengthHeight,
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: AppSpacing.s),
          Text(
            '${(strength * 100).toInt()}%',
            style: context.typography.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontFamily: theme.passwordText.fontFamily,
            ),
          ),
        ],
      ],
    );
  }
}
