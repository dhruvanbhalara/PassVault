import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final double strength;

  const PasswordStrengthIndicator({super.key, required this.strength});

  Color _getStrengthColor(BuildContext context) {
    final theme = context.theme;
    if (strength <= 0.25) return theme.strengthWeak;
    if (strength <= 0.5) return theme.strengthFair;
    if (strength <= 0.75) return theme.strengthGood;
    return theme.strengthStrong;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStrengthColor(context);

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xxs),
            child: LinearProgressIndicator(
              value: strength,
              backgroundColor: context.theme.securitySurface,
              color: color,
              minHeight: AppDimensions.passwordStrengthHeight,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Text(
          '${(strength * 100).toInt()}%',
          style: context.typography.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            fontFamily: context.theme.passwordText.fontFamily,
          ),
        ),
      ],
    );
  }
}
