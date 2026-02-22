import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.theme;
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;

    return Row(
      crossAxisAlignment: hasSubtitle
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        if (showBack)
          IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            icon: const Icon(LucideIcons.chevronLeft),
            color: colors.onSurface,
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          )
        else
          const SizedBox(width: AppSpacing.s),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: typography.headlineSmall),
              if (hasSubtitle) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle!,
                  style: typography.bodyMedium?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.s),
          trailing!,
        ],
      ],
    );
  }
}
