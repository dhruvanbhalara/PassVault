import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/l10n/app_localizations.dart';

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
    final theme = context.theme;
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
              theme: theme,
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
  final AppThemeExtension theme;
  final AppLocalizations l10n;
  final VoidCallback onEdit;

  const ActiveStrategyCard({
    super.key,
    required this.strategy,
    required this.theme,
    required this.l10n,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: theme.cardShadow.color.withValues(alpha: 0.4),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: theme.vaultGradient,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [theme.cardShadow],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Row(
              children: [
                _StatusBadge(theme: theme),
                const SizedBox(width: AppSpacing.l),
                _StrategyInfo(strategy: strategy, theme: theme, l10n: l10n),
                IconButton(
                  key: Key('edit_strategy_${strategy.id}'),
                  icon: Icon(
                    LucideIcons.pencil,
                    color: theme.onVaultGradient,
                    size: AppDimensions.strategyIconMedium,
                  ),
                  onPressed: onEdit,
                ),
              ],
            ),
          ),
        ),
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
        color: theme.onVaultGradient.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.onVaultGradient.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Icon(
        LucideIcons.check,
        color: theme.onVaultGradient,
        size: AppIconSize.l,
      ),
    );
  }
}

class _StrategyInfo extends StatelessWidget {
  final PasswordGenerationStrategy strategy;
  final AppThemeExtension theme;
  final AppLocalizations l10n;

  const _StrategyInfo({
    required this.strategy,
    required this.theme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strategy.name,
            style: context.typography.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.onVaultGradient,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${l10n.passwordLength}: ${strategy.length}',
            style: context.typography.bodyMedium?.copyWith(
              color: theme.onVaultGradient.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
