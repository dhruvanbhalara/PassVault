import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

/// A reusable list option component with icon, title, subtitle, and optional trailing.
///
/// This widget consolidates the common pattern seen in `PickerOption` and similar
/// components across the app. It follows the design system tokens and includes
/// full accessibility support.
///
/// Example:
/// ```dart
/// AppListOption(
///   icon: LucideIcons.fileText,
///   iconColor: Colors.blue,
///   title: 'Import from CSV',
///   subtitle: 'Import passwords from a CSV file',
///   onTap: () => _handleImport(),
/// )
/// ```
class AppListOption extends StatelessWidget {
  /// The icon to display in the leading badge.
  final IconData icon;

  /// The color for the icon and badge background.
  final Color iconColor;

  /// The main title text.
  final String title;

  /// The subtitle/description text.
  final String subtitle;

  /// Callback when the option is tapped.
  final VoidCallback onTap;

  /// Optional custom trailing widget (defaults to chevron right).
  final Widget? trailing;

  /// Optional semantic label override (defaults to title).
  final String? semanticLabel;

  const AppListOption({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel ?? title,
      hint: subtitle,
      child: ListTile(
        leading: _AppListOptionIcon(icon: icon, color: iconColor),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: context.typography.bodySmall?.copyWith(
            color: context.theme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        trailing:
            trailing ??
            Icon(
              LucideIcons.chevronRight,
              color: context.theme.onSurface.withValues(alpha: 0.3),
            ),
        onTap: onTap,
      ),
    );
  }
}

/// Private icon badge component for AppListOption.
class _AppListOptionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _AppListOptionIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Option icon',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s),
          child: Icon(icon, color: color, size: AppIconSize.m),
        ),
      ),
    );
  }
}
