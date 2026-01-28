import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

/// A header widget for grouped settings sections with premium typography.
class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.s,
        top: context.responsive(AppSpacing.l, tablet: AppSpacing.xl),
        right: AppSpacing.s,
        bottom: AppSpacing.m,
      ),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: context.typography.labelLarge?.copyWith(
              color: context.theme.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Divider(
              color: context.theme.primary.withValues(alpha: 0.1),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
