import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
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
