import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';
import 'package:passvault/features/generator/presentation/widgets/generator_sections.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

import '../widgets/strategy_preview_card.dart';

class StrategyEditor extends StatefulWidget {
  final PasswordGenerationStrategy strategy;
  final ValueChanged<PasswordGenerationStrategy> onChanged;

  const StrategyEditor({
    super.key,
    required this.strategy,
    required this.onChanged,
  });

  @override
  State<StrategyEditor> createState() => _StrategyEditorState();
}

class _StrategyEditorState extends State<StrategyEditor> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.strategy.name);
  }

  @override
  void didUpdateWidget(StrategyEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.strategy.name != widget.strategy.name) {
      if (_nameController.text != widget.strategy.name) {
        _nameController.text = widget.strategy.name;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.strategy;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.xl,
        children: [
          StrategyPreviewCard(settings: settings),
          _StrategyNameInput(
            controller: _nameController,
            onChanged: (value) =>
                widget.onChanged(settings.copyWith(name: value)),
          ),
          PasswordGenerationControlsCard(
            strategy: settings,
            controlsPrefix: 'strategy_editor',
            onLengthChanged: (value) =>
                widget.onChanged(settings.copyWith(length: value)),
            onUppercaseChanged: (value) =>
                widget.onChanged(settings.copyWith(useUppercase: value)),
            onLowercaseChanged: (value) =>
                widget.onChanged(settings.copyWith(useLowercase: value)),
            onNumbersChanged: (value) =>
                widget.onChanged(settings.copyWith(useNumbers: value)),
            onSymbolsChanged: (value) =>
                widget.onChanged(settings.copyWith(useSpecialChars: value)),
            onExcludeAmbiguousChanged: (value) => widget.onChanged(
              settings.copyWith(excludeAmbiguousChars: value),
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategyNameInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _StrategyNameInput({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final textTheme = context.typography;

    return TextField(
      controller: controller,
      style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: l10n.strategyName,
        hintText: l10n.hintStrategyName,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
          borderSide: BorderSide(color: theme.primary, width: 2),
        ),
        prefixIcon: Icon(LucideIcons.tag, color: colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
      ),
      onChanged: onChanged,
    );
  }
}
