import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

/// A reusable toggle tile for settings options.
class StrategyOptionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final IconData icon;
  final ValueChanged<bool> onChanged;

  const StrategyOptionTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      secondary: Container(
        padding: const EdgeInsets.all(AppSpacing.s),
        decoration: BoxDecoration(
          color: theme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: Icon(icon, color: theme.primary, size: 20),
      ),
      title: Text(
        title,
        style: context.typography.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: context.typography.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      activeTrackColor: theme.primary,
      activeThumbColor: theme.onPrimary,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.l),
      ),
    );
  }
}
