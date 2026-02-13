import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

class ActiveStrategySection extends StatelessWidget {
  final PasswordGenerationSettings settings;
  final AppLocalizations l10n;
  final ValueChanged<PasswordGenerationStrategy> onEdit;

  const ActiveStrategySection({
    super.key,
    required this.settings,
    required this.l10n,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final activeStrategy = settings.strategies.firstWhere(
      (s) => s.id == settings.defaultStrategyId,
      orElse: () => settings.strategies.first,
    );

    return SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.l),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionHeader(title: l10n.activeConfiguration),
            ActiveStrategyCard(
              strategy: activeStrategy,
              l10n: l10n,
              onEdit: () => onEdit(activeStrategy),
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveStrategyCard extends StatelessWidget {
  final PasswordGenerationStrategy strategy;
  final AppLocalizations l10n;
  final VoidCallback onEdit;

  const ActiveStrategyCard({
    super.key,
    required this.strategy,
    required this.l10n,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return AppCard(
      hasOutline: true,
      onTap: onEdit,
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Row(
        children: [
          _StatusBadge(theme: theme),
          const SizedBox(width: AppSpacing.l),
          _StrategyInfo(strategy: strategy, l10n: l10n),
          const SizedBox(width: AppSpacing.m),
          Container(
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              key: Key('edit_strategy_${strategy.id}'),
              icon: Icon(
                LucideIcons.pencil,
                color: colorScheme.onSurface,
                size: AppDimensions.strategyIconSmall,
              ),
              onPressed: onEdit,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AppThemeExtension theme;
  const _StatusBadge({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.primary.withValues(alpha: 0.28),
          width: 1,
        ),
      ),
      child: Icon(LucideIcons.check, color: theme.primary, size: AppIconSize.l),
    );
  }
}

class _StrategyInfo extends StatelessWidget {
  final PasswordGenerationStrategy strategy;
  final AppLocalizations l10n;

  const _StrategyInfo({required this.strategy, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strategy.name,
            style: context.typography.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${l10n.passwordLength}: ${strategy.length}',
            style: context.typography.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
