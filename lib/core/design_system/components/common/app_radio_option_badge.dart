import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

class AppRadioOptionBadge extends StatelessWidget {
  final String text;
  final Color color;

  const AppRadioOptionBadge({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.s),
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
}
