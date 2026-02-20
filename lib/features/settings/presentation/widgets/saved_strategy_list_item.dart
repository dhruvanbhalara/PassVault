import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings/settings_bloc.dart';

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
        AppSpacing.x4xl + 56,
      ),
      sliver: SliverList.separated(
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.m),
        itemCount: nonDefaultStrategies.length + 1,
        itemBuilder: (context, index) {
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
        },
      ),
    );
  }
}

class _SavedHeader extends StatelessWidget {
  final AppLocalizations l10n;
  const _SavedHeader({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return AppSectionHeader(title: l10n.savedStrategies);
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
    final typography = context.typography;

    return Dismissible(
      key: Key(strategy.id),
      background: _DismissibleBackground(strategy: strategy),
      direction: DismissDirection.endToStart,
      onDismissed: (_) =>
          context.read<SettingsBloc>().add(DeleteStrategy(strategy.id)),
      child: AppCard(
        hasGlow: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strategy.name,
                    style: typography.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${l10n.passwordLength}: ${strategy.length}',
                    style: typography.bodyMedium?.copyWith(
                      color: theme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            _EditButton(
              onPressed: onEdit,
              key: Key('edit_saved_strategy_${strategy.id}'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(LucideIcons.pencil),
      onPressed: onPressed,
    );
  }
}

class _DismissibleBackground extends StatelessWidget {
  final PasswordGenerationStrategy strategy;

  const _DismissibleBackground({required this.strategy});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.l),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.l),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            key: Key('delete_saved_strategy_${strategy.id}'),
            LucideIcons.trash2,
            color: context.colorScheme.onErrorContainer,
          ),
        ),
      ),
    );
  }
}
