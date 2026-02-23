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

    return SizedBox(
      height: hasSubtitle ? 64 : 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: showBack
                ? IconButton(
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    icon: const Icon(LucideIcons.chevronLeft),
                    color: colors.onSurface,
                    onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                  )
                : const SizedBox(width: AppSpacing.s),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: typography.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                if (hasSubtitle) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: typography.bodyMedium?.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null)
            Align(alignment: Alignment.centerRight, child: trailing),
        ],
      ),
    );
  }
}
