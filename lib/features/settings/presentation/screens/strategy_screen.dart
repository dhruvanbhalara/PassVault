import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/config/routes/app_routes.dart';
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

    return Scaffold(
      backgroundColor: theme.background,
      floatingActionButton: FloatingActionButton(
        key: const Key('add_strategy_fab'),
        onPressed: () {
          _showEditor(context, 'new');
        },
        child: const Icon(LucideIcons.plus),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final settings = state.passwordSettings;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(l10n.strategy),
                centerTitle: true,
                floating: true,
                pinned: true,
                scrolledUnderElevation: 0,
                backgroundColor: theme.background,
              ),
              if (settings.strategies.isEmpty)
                EmptyStrategiesPlaceholder(l10n: l10n, theme: theme)
              else ...[
                ActiveStrategySection(
                  settings: settings,
                  l10n: l10n,
                  onEdit: (strategy) => _showEditor(context, strategy.id),
                ),
                if (settings.strategies.length > 1)
                  SavedStrategiesSection(
                    settings: settings,
                    l10n: l10n,
                    onEdit: (strategy) => _showEditor(context, strategy.id),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _showEditor(BuildContext context, String strategyId) {
    context.push(AppRoutes.strategyEditor, extra: {'strategyId': strategyId});
  }
}
