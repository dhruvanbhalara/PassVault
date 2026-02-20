import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

/// A widget for displaying password strength with semantic colors.
class PasswordStrengthWidget extends StatelessWidget {
  final double strength;

  const PasswordStrengthWidget({super.key, required this.strength});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final typography = context.typography;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.strength,
          style: typography.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: _strengthColor(strength, theme).withAlpha(30),
            borderRadius: BorderRadius.circular(AppSpacing.s),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.xs,
            ),
            child: Text(
              _strengthText(strength, l10n),
              style: typography.labelMedium?.copyWith(
                color: _strengthColor(strength, theme),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _strengthText(double strength, AppLocalizations l10n) {
    if (strength <= 0.15) return l10n.strengthVeryWeak;
    if (strength <= 0.35) return l10n.strengthWeak;
    if (strength <= 0.55) return l10n.strengthFair;
    if (strength <= 0.75) return l10n.strengthGood;
    if (strength <= 0.90) return l10n.strengthStrong;
    return l10n.strengthVeryStrong;
  }

  Color _strengthColor(double strength, AppThemeExtension theme) {
    if (strength <= 0.15) return theme.strengthVeryWeak;
    if (strength <= 0.35) return theme.strengthWeak;
    if (strength <= 0.55) return theme.strengthFair;
    if (strength <= 0.75) return theme.strengthGood;
    if (strength <= 0.90) return theme.strengthStrong;
    return theme.strengthVeryStrong;
  }
}
