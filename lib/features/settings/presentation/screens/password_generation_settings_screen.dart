import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/screens/strategy_editor.dart';
import 'package:passvault/l10n/app_localizations.dart';

/// Screen to configure password generation preferences.
class PasswordGenerationSettingsScreen extends StatelessWidget {
  const PasswordGenerationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsBloc>()..add(const LoadSettings()),
      child: const _PasswordGenerationSettingsView(),
    );
  }
}

class _PasswordGenerationSettingsView extends StatelessWidget {
  const _PasswordGenerationSettingsView();

  void _showEditor(
    BuildContext context, {
    required PasswordGenerationStrategy strategy,
    required bool isNew,
  }) {
    final settingsBloc = context.read<SettingsBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return BlocProvider.value(
          value: settingsBloc,
          child: _StrategyEditorSheet(strategy: strategy, isNew: isNew),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.background, // Explicitly use theme background
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEditor(
            context,
            strategy: PasswordGenerationStrategy.create(name: l10n.newStrategy),
            isNew: true,
          );
        },
        child: const Icon(LucideIcons.plus),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final settings = state.passwordSettings;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(l10n.passwordGeneration),
                centerTitle: true,
                floating: true,
                pinned: true,
                scrolledUnderElevation: 0,
                backgroundColor: Colors.transparent,
              ),
              if (settings.strategies.isEmpty)
                _EmptyStrategiesPlaceholder(l10n: l10n, theme: theme)
              else ...[
                _ActiveStrategySection(
                  settings: settings,
                  l10n: l10n,
                  onEdit: (strategy) =>
                      _showEditor(context, strategy: strategy, isNew: false),
                ),
                if (settings.strategies.length > 1)
                  _SavedStrategiesSection(
                    settings: settings,
                    l10n: l10n,
                    onEdit: (strategy) =>
                        _showEditor(context, strategy: strategy, isNew: false),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _EmptyStrategiesPlaceholder extends StatelessWidget {
  final AppLocalizations l10n;
  final AppThemeExtension theme;

  const _EmptyStrategiesPlaceholder({required this.l10n, required this.theme});

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

class _ActiveStrategySection extends StatelessWidget {
  final PasswordGenerationSettings settings;
  final AppLocalizations l10n;
  final ValueChanged<PasswordGenerationStrategy> onEdit;

  const _ActiveStrategySection({
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
            _ActiveStrategyCard(
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

class _ActiveStrategyCard extends StatelessWidget {
  final PasswordGenerationStrategy strategy;
  final AppThemeExtension theme;
  final AppLocalizations l10n;
  final VoidCallback onEdit;

  const _ActiveStrategyCard({
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

class _SavedStrategiesSection extends StatelessWidget {
  final PasswordGenerationSettings settings;
  final AppLocalizations l10n;
  final ValueChanged<PasswordGenerationStrategy> onEdit;

  const _SavedStrategiesSection({
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
        AppSpacing.l, // Added top padding to match previous structure
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
          return _StrategyListItem(
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

class _StrategyListItem extends StatelessWidget {
  final PasswordGenerationStrategy strategy;
  final AppLocalizations l10n;
  final VoidCallback onEdit;

  const _StrategyListItem({
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

class _StrategyEditorSheet extends StatefulWidget {
  final PasswordGenerationStrategy strategy;
  final bool isNew;

  const _StrategyEditorSheet({required this.strategy, required this.isNew});

  @override
  State<_StrategyEditorSheet> createState() => _StrategyEditorSheetState();
}

class _StrategyEditorSheetState extends State<_StrategyEditorSheet> {
  late PasswordGenerationStrategy _currentStrategy;

  @override
  void initState() {
    super.initState();
    _currentStrategy = widget.strategy;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isNew ? l10n.newStrategy : l10n.editStrategy,
                    style: context.typography.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.check),
                    onPressed: () {
                      if (widget.isNew) {
                        context.read<SettingsBloc>().add(
                          AddStrategy(_currentStrategy),
                        );
                      } else {
                        context.read<SettingsBloc>().add(
                          UpdateStrategy(_currentStrategy),
                        );
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.m),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: StrategyEditor(
                    strategy: _currentStrategy,
                    onChanged: (newStrategy) {
                      setState(() {
                        _currentStrategy = newStrategy;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
