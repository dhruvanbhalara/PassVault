import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/screens/strategy_editor.dart';

class StrategyEditorScreen extends StatefulWidget {
  final String? strategyId;

  const StrategyEditorScreen({super.key, required this.strategyId});

  @override
  State<StrategyEditorScreen> createState() => _StrategyEditorScreenState();
}

class _StrategyEditorScreenState extends State<StrategyEditorScreen> {
  late PasswordGenerationStrategy _currentStrategy;
  late ScrollController _scrollController;
  bool _isNew = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeStrategy();
    });
  }

  void _initializeStrategy() {
    final state = context.read<SettingsBloc>().state;
    if (widget.strategyId == 'new') {
      _currentStrategy = PasswordGenerationStrategy.create(
        name: context.l10n.newStrategy,
      );
      _isNew = true;
      _initialized = true;
    } else {
      try {
        _currentStrategy = state.passwordSettings.strategies.firstWhere(
          (s) => s.id == widget.strategyId,
        );
        _initialized = true;
      } catch (_) {
        // If not found, show error or redirect
        _initialized = false;
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    if (!_initialized) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.errorOccurred)),
        body: Center(
          child: Text('${l10n.errorOccurred}: ${l10n.noStrategiesFound}'),
        ),
      );
    }

    final title = _isNew ? l10n.newStrategy : l10n.editStrategy;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: PersistentBottomBar(
            scrollController: _scrollController,
            child: FloatingActionButton.extended(
              key: const Key('strategy_editor_save_fab'),
              onPressed: state is SettingsLoading ? null : _saveStrategy,
              backgroundColor: theme.primary,
              foregroundColor: theme.onPrimary,
              icon: state is SettingsLoading
                  ? const SizedBox(
                      width: AppIconSize.m,
                      height: AppIconSize.m,
                      child: AppLoader(key: Key('strategy_editor_loader')),
                    )
                  : const Icon(LucideIcons.save),
              label: Text(l10n.save),
            ),
          ),
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                centerTitle: true,
                title: Text(title),
                floating: true,
                pinned: true,
                scrolledUnderElevation: 0,
                backgroundColor: theme.background,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.l),
                sliver: SliverToBoxAdapter(
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

  void _saveStrategy() {
    if (_isNew) {
      context.read<SettingsBloc>().add(AddStrategy(_currentStrategy));
    } else {
      context.read<SettingsBloc>().add(UpdateStrategy(_currentStrategy));
    }
    context.pop();
  }
}
