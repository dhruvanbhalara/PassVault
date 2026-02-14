import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/screens/strategy_editor.dart';

class StrategyEditorSheet extends StatefulWidget {
  final PasswordGenerationStrategy strategy;
  final bool isNew;

  const StrategyEditorSheet({
    super.key,
    required this.strategy,
    required this.isNew,
  });

  @override
  State<StrategyEditorSheet> createState() => _StrategyEditorSheetState();
}

class _StrategyEditorSheetState extends State<StrategyEditorSheet> {
  late PasswordGenerationStrategy _currentStrategy;

  @override
  void initState() {
    super.initState();
    _currentStrategy = widget.strategy;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = widget.isNew ? l10n.newStrategy : l10n.editStrategy;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.96,
      expand: false,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.theme.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.s),
              const _DragHandle(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.l,
                  AppSpacing.s,
                  AppSpacing.l,
                  AppSpacing.s,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: context.typography.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.cancel,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(LucideIcons.x),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.l,
                        AppSpacing.s,
                        AppSpacing.l,
                        AppSpacing.m,
                      ),
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
              ),
              SafeArea(
                top: false,
                minimum: const EdgeInsets.fromLTRB(
                  AppSpacing.l,
                  AppSpacing.s,
                  AppSpacing.l,
                  AppSpacing.m,
                ),
                child: AppButton(
                  text: l10n.save,
                  icon: LucideIcons.check,
                  onPressed: _saveStrategy,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveStrategy() {
    if (widget.isNew) {
      context.read<SettingsBloc>().add(AddStrategy(_currentStrategy));
    } else {
      context.read<SettingsBloc>().add(UpdateStrategy(_currentStrategy));
    }
    Navigator.pop(context);
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 4,
      decoration: BoxDecoration(
        color: context.theme.onSurface.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );
  }
}
