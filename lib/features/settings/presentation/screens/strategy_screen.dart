import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/presentation/bloc/settings/settings_bloc.dart';

import '../widgets/active_strategy_card.dart';
import '../widgets/empty_strategies_placeholder.dart';
import '../widgets/saved_strategy_list_item.dart';

/// Screen to configure password generation preferences.
class StrategyScreen extends StatelessWidget {
  const StrategyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return AppFeatureShell(
      title: l10n.strategy,
      showBack: true,
      onBack: () => context.pop(),
      backgroundColor: theme.background,
      floatingActionButton: FloatingActionButton(
        key: const Key('add_strategy_fab'),
        heroTag: 'add_strategy_fab',
        onPressed: () {
          _showEditor(context, 'new');
        },
        child: const Icon(LucideIcons.plus),
      ),
      slivers: [
        _StrategyContentSliver(
          onEdit: (strategyId) => _showEditor(context, strategyId),
        ),
      ],
    );
  }

  void _showEditor(BuildContext context, String strategyId) {
    context.push(AppRoutes.strategyEditor, extra: {'strategyId': strategyId});
  }
}

class _StrategyContentSliver extends StatelessWidget {
  final ValueChanged<String> onEdit;

  const _StrategyContentSliver({required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final settings = state.passwordSettings;

        if (settings.strategies.isEmpty) {
          return EmptyStrategiesPlaceholder(l10n: l10n, theme: theme);
        }

        return SliverMainAxisGroup(
          slivers: [
            ActiveStrategySection(
              settings: settings,
              l10n: l10n,
              onEdit: (strategy) => onEdit(strategy.id),
            ),
            if (settings.strategies.length > 1)
              SavedStrategiesSection(
                settings: settings,
                l10n: l10n,
                onEdit: (strategy) => onEdit(strategy.id),
              ),
          ],
        );
      },
    );
  }
}
