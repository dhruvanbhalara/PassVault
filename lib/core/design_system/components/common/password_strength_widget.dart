import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';
import 'package:password_engine/password_engine.dart' show PasswordStrength;

/// A premium widget for displaying password strength with fluid progress and pulse animations.
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
    final progress = _strengthProgress(strength.strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.strength,
              style: typography.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: labelColor,
              ),
            ),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: typography.labelMedium!.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              child: Text(text),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        Stack(
          children: [
            // Background track
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.surfaceDim,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            // Progress bar
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              widthFactor: progress,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  double _strengthProgress(PasswordStrength strength) {
    return switch (strength) {
      PasswordStrength.veryWeak => 0.2,
      PasswordStrength.weak => 0.4,
      PasswordStrength.medium => 0.6,
      PasswordStrength.strong => 0.8,
      PasswordStrength.veryStrong => 1.0,
    };
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
