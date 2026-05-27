import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';
import 'package:password_engine/password_engine.dart' show PasswordStrength;

/// A premium widget for displaying password strength with fluid progress and pulse animations.
class PasswordStrengthWidget extends StatelessWidget {
  final PasswordFeedback strength;
  final Color? labelColor;
  final Color? valueColor;

  const PasswordStrengthWidget({
    super.key,
    required this.strength,
    this.labelColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final typography = context.typography;

    final color = _strengthColor(strength.strength, theme);
    final text = _strengthText(strength.strength, l10n);

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
                color: valueColor ?? color,
                fontWeight: FontWeight.bold,
              ),
              child: Text(text),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        Row(
          children: List.generate(5, (index) {
            final isActive = index < _strengthSegmentCount(strength.strength);
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 6,
                margin: EdgeInsets.only(right: index == 4 ? 0 : AppSpacing.xs),
                decoration: BoxDecoration(
                  color: isActive
                      ? (labelColor ?? color)
                      : (labelColor?.withValues(alpha: 0.2) ??
                            theme.surfaceDim),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: (labelColor ?? color).withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  int _strengthSegmentCount(PasswordStrength strength) {
    return switch (strength) {
      PasswordStrength.veryWeak => 1,
      PasswordStrength.weak => 2,
      PasswordStrength.medium => 3,
      PasswordStrength.strong => 4,
      PasswordStrength.veryStrong => 5,
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
