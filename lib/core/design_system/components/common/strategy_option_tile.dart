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
    final colorScheme = context.colorScheme;

    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.s,
      ),
      secondary: Icon(
        icon,
        color: value
            ? theme.primary
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        size: AppIconSize.m,
      ),
      title: Text(
        title,
        style: context.typography.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: context.typography.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      value: value,
      onChanged: onChanged,
      activeThumbColor: theme.primary,
      activeTrackColor: theme.primary.withValues(alpha: 0.2),
      inactiveThumbColor: colorScheme.outline,
      inactiveTrackColor: colorScheme.surfaceContainerHighest,
    );
  }
}
