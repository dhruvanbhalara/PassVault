import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';
import 'package:passvault/l10n/app_localizations.dart';

class EmptyStrategiesPlaceholder extends StatelessWidget {
  final AppLocalizations l10n;
  final AppThemeExtension theme;

  const EmptyStrategiesPlaceholder({
    super.key,
    required this.l10n,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.scrollText,
              size: AppDimensions.emptyStateIconSize,
              color: theme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              l10n.noStrategiesFound,
              style: context.typography.titleMedium?.copyWith(
                color: theme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              l10n.noStrategiesDescription,
              style: context.typography.bodyMedium?.copyWith(
                color: theme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
