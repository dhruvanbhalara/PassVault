import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

/// Icon wrapper for metric-style icons in list tiles.
class SettingsMetricIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const SettingsMetricIcon({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Icon(icon, color: color, size: AppIconSize.m),
      ),
    );
  }
}
