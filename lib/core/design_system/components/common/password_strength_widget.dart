import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';
import 'package:password_engine/password_engine.dart' show PasswordStrength;

/// A widget for displaying password strength with semantic colors.
class PasswordStrengthWidget extends StatelessWidget {
  final PasswordFeedback strength;
  final Color? labelColor;

  const PasswordStrengthWidget({
    super.key,
    required this.strength,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final typography = context.typography;

    final color = _strengthColor(strength.strength, theme);
    final text = _strengthText(strength.strength, l10n);

    return Row(
      children: [
        Expanded(
          child: Text(
            l10n.strength,
            overflow: TextOverflow.ellipsis,
            style: typography.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.s),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.xs,
                ),
                child: Text(
                  text,
                  key: ValueKey(text),
                  overflow: TextOverflow.ellipsis,
                  style: typography.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _strengthText(PasswordStrength strength, AppLocalizations l10n) {
    return switch (strength) {
      PasswordStrength.veryWeak => l10n.strengthVeryWeak,
      PasswordStrength.weak => l10n.strengthWeak,
      PasswordStrength.medium => l10n.strengthFair,
      PasswordStrength.strong => l10n.strengthStrong,
      PasswordStrength.veryStrong => l10n.strengthVeryStrong,
    };
  }

  Color _strengthColor(PasswordStrength strength, AppThemeExtension theme) {
    return switch (strength) {
      PasswordStrength.veryWeak => theme.strengthVeryWeak,
      PasswordStrength.weak => theme.strengthWeak,
      PasswordStrength.medium => theme.strengthFair,
      PasswordStrength.strong => theme.strengthStrong,
      PasswordStrength.veryStrong => theme.strengthVeryStrong,
    };
  }
}
