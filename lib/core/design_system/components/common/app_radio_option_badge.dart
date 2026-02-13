import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

class AppRadioOptionBadge extends StatelessWidget {
  final String text;
  final Color color;
  final bool isAmoled;

  const AppRadioOptionBadge({
    super.key,
    required this.text,
    required this.color,
    required this.isAmoled,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    if (isAmoled) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.s),
          border: Border.all(color: color.withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.30),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Text(
          text,
          style: typography.labelSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      );
    }

    final isDark = context.isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? color.withValues(alpha: 0.15)
            : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Text(
        text,
        style: typography.labelSmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: isDark ? color.withValues(alpha: 0.9) : color,
        ),
      ),
    );
  }
}
