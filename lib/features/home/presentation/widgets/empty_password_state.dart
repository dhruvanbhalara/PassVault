import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

class EmptyPasswordState extends StatelessWidget {
  const EmptyPasswordState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Icon(
                  LucideIcons.shieldCheck,
                  size: context.responsive(
                    AppDimensions.emptyStateIconSize,
                    tablet: AppDimensions.emptyStateIconSizeTablet,
                  ),
                  color: theme.primary.withValues(alpha: 0.4),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              context.l10n.noPasswords,
              key: const Key('home_empty_text'),
              textAlign: TextAlign.center,
              style: context.typography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
