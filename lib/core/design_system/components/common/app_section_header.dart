import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

/// A labeled header for sections with standardized styling.
///
/// Supports two variants:
/// - `simple`: Basic header with bold text (default)
/// - `premium`: Header with uppercase text, increased letter spacing, and divider line
///
/// Follows the design system tokens for spacing and typography.
///
/// Example:
/// ```dart
/// // Simple header
/// AppSectionHeader(
///   title: 'Recent Passwords',
/// )
///
/// // Premium header with divider
/// AppSectionHeader(
///   title: 'Security Settings',
///   variant: AppSectionHeaderVariant.premium,
/// )
/// ```
class AppSectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final AppSectionHeaderVariant variant;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.variant = AppSectionHeaderVariant.simple,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: title,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.s,
          top: variant == AppSectionHeaderVariant.premium
              ? context.responsive(AppSpacing.l, tablet: AppSpacing.xl)
              : 0,
          right: AppSpacing.s,
          bottom: AppSpacing.s,
        ),
        child: variant == AppSectionHeaderVariant.premium
            ? _PremiumHeaderContent(title: title, trailing: trailing)
            : _SimpleHeaderContent(title: title, trailing: trailing),
      ),
    );
  }
}

/// Simple variant of section header with compact styling.
class _SimpleHeaderContent extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _SimpleHeaderContent({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: context.typography.labelSmall?.copyWith(
            color: theme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Premium variant of section header with divider line and enhanced typography.
class _PremiumHeaderContent extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const _PremiumHeaderContent({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: context.typography.labelLarge?.copyWith(
            color: theme.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: Divider(
            color: theme.primary.withValues(alpha: 0.1),
            thickness: 1,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.m),
          trailing!,
        ],
      ],
    );
  }
}

/// Variant styles for AppSectionHeader.
enum AppSectionHeaderVariant {
  /// Simple header with compact styling.
  simple,

  /// Premium header with divider line and enhanced typography.
  premium,
}
