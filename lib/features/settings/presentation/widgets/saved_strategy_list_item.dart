import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/l10n/app_localizations.dart';

class SavedStrategiesSection extends StatelessWidget {
  final PasswordGenerationSettings settings;
  final AppLocalizations l10n;
  final ValueChanged<PasswordGenerationStrategy> onEdit;

  const SavedStrategiesSection({
    super.key,
    required this.settings,
    required this.l10n,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final nonDefaultStrategies = settings.strategies
        .where((s) => s.id != settings.defaultStrategyId)
        .toList();

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.x4xl + 80,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index == 0) {
            return _SavedHeader(l10n: l10n);
          }
          final strategyIndex = index - 1;
          if (strategyIndex >= nonDefaultStrategies.length) return null;
          final strategy = nonDefaultStrategies[strategyIndex];
          return StrategyListItem(
            strategy: strategy,
            l10n: l10n,
            onEdit: () => onEdit(strategy),
          );
        }, childCount: nonDefaultStrategies.length + 1),
      ),
    );
  }
}

class _SavedHeader extends StatelessWidget {
  final AppLocalizations l10n;
  const _SavedHeader({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.s, bottom: AppSpacing.s),
      child: AppSectionHeader(title: l10n.savedStrategies),
    );
  }
}

class StrategyListItem extends StatelessWidget {
  final PasswordGenerationStrategy strategy;
  final AppLocalizations l10n;
  final VoidCallback onEdit;

  const StrategyListItem({
    super.key,
    required this.strategy,
    required this.l10n,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Card(
        elevation: 0,
        color: context.colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
          side: BorderSide(color: theme.outline.withValues(alpha: 0.1)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.l),
          onTap: () {
            context.read<SettingsBloc>().add(SetDefaultStrategy(strategy.id));
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Row(
              children: [
                _TrailingIconPlaceholder(theme: theme),
                const SizedBox(width: AppSpacing.m),
                _ListItemInfo(strategy: strategy, l10n: l10n),
                _ListItemActions(
                  strategy: strategy,
                  l10n: l10n,
                  onEdit: onEdit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrailingIconPlaceholder extends StatelessWidget {
  final AppThemeExtension theme;
  const _TrailingIconPlaceholder({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(color: theme.outline.withValues(alpha: 0.1)),
      ),
      child: Icon(
        LucideIcons.slidersHorizontal,
        color: context.colorScheme.onSurfaceVariant,
        size: 18,
      ),
    );
  }
}

class _ListItemInfo extends StatelessWidget {
  final PasswordGenerationStrategy strategy;
  final AppLocalizations l10n;

  const _ListItemInfo({required this.strategy, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strategy.name,
            style: context.typography.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${l10n.passwordLength}: ${strategy.length}',
            style: context.typography.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ListItemActions extends StatelessWidget {
  final PasswordGenerationStrategy strategy;
  final AppLocalizations l10n;
  final VoidCallback onEdit;

  const _ListItemActions({
    required this.strategy,
    required this.l10n,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            LucideIcons.arrowUpFromLine,
            size: AppDimensions.strategyIconSmall,
            color: theme.primary,
          ),
          tooltip: l10n.setAsDefault,
          onPressed: () =>
              context.read<SettingsBloc>().add(SetDefaultStrategy(strategy.id)),
        ),
        IconButton(
          key: Key('edit_saved_strategy_${strategy.id}'),
          icon: Icon(
            LucideIcons.pencil,
            size: AppDimensions.strategyIconSmall,
            color: context.colorScheme.onSurfaceVariant,
          ),
          onPressed: onEdit,
        ),
        IconButton(
          icon: Icon(
            LucideIcons.trash2,
            size: AppDimensions.strategyIconSmall,
            color: theme.error,
          ),
          onPressed: () =>
              context.read<SettingsBloc>().add(DeleteStrategy(strategy.id)),
        ),
      ],
    );
  }
}
