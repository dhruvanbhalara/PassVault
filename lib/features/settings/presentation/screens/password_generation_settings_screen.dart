import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';

import '../widgets/active_strategy_card.dart';
import '../widgets/empty_strategies_placeholder.dart';
import '../widgets/saved_strategy_list_item.dart';
import '../widgets/strategy_editor_sheet.dart';

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
          child: StrategyEditorSheet(strategy: strategy, isNew: isNew),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Scaffold(
      backgroundColor: theme.background,
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
                EmptyStrategiesPlaceholder(l10n: l10n, theme: theme)
              else ...[
                ActiveStrategySection(
                  settings: settings,
                  l10n: l10n,
                  onEdit: (strategy) =>
                      _showEditor(context, strategy: strategy, isNew: false),
                ),
                if (settings.strategies.length > 1)
                  SavedStrategiesSection(
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
