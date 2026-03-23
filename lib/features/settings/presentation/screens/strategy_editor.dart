import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/generator/presentation/widgets/password_generation_controls_card.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/entities/password_strategy_type.dart';
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
  static const double _controlsMinHeight = 360;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.xl,
      children: [
        _StrategyTypeSelector(
          type: settings.type,
          onChanged: (value) =>
              widget.onChanged(settings.copyWith(type: value)),
        ),
        StrategyPreviewCard(settings: settings),
        _StrategyNameInput(
          controller: _nameController,
          onChanged: (value) =>
              widget.onChanged(settings.copyWith(name: value)),
        ),
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 400),
              reverse: settings.type == PasswordStrategyType.random,
              layoutBuilder: (entries) => Stack(children: entries),
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                return SharedAxisTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                  fillColor: context.colorScheme.surface.withValues(alpha: 0),
                  child: child,
                );
              },
              child:
                  ConstrainedBox(
                        key: ValueKey(settings.type),
                        constraints: const BoxConstraints(
                          minHeight: _controlsMinHeight,
                        ),
                        child: PasswordGenerationControlsCard(
                          strategy: settings,
                          controlsPrefix: 'strategy_editor',
                          onLengthChanged: (value) => widget.onChanged(
                            settings.copyWith(length: value),
                          ),
                          onUppercaseChanged: (value) => widget.onChanged(
                            settings.copyWith(useUppercase: value),
                          ),
                          onLowercaseChanged: (value) => widget.onChanged(
                            settings.copyWith(useLowercase: value),
                          ),
                          onNumbersChanged: (value) => widget.onChanged(
                            settings.copyWith(useNumbers: value),
                          ),
                          onSymbolsChanged: (value) => widget.onChanged(
                            settings.copyWith(useSpecialChars: value),
                          ),
                          onExcludeAmbiguousChanged: (value) =>
                              widget.onChanged(
                                settings.copyWith(excludeAmbiguousChars: value),
                              ),
                          onWordCountChanged: (value) => widget.onChanged(
                            settings.copyWith(wordCount: value),
                          ),
                          onSeparatorChanged: (value) => widget.onChanged(
                            settings.copyWith(separator: value),
                          ),
                        ),
                      )
                      .animate(key: ValueKey(settings.type))
                      .fadeIn(duration: 300.ms, curve: Curves.easeOut),
            ),
          ),
        ),
      ],
    );
  }
}

class _StrategyNameInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _StrategyNameInput({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final textTheme = context.typography;
    return TextField(
          controller: controller,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            labelText: context.l10n.strategyName,
            labelStyle: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            hintText: context.l10n.hintStrategyName,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.l),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.l),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.l),
              borderSide: BorderSide(color: theme.primary, width: 2),
            ),
            prefixIcon: Icon(
              LucideIcons.tag,
              color: theme.primary.withValues(alpha: 0.7),
              size: 20,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
              vertical: AppSpacing.m,
            ),
          ),
          onChanged: onChanged,
        )
        .animate()
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOutQuad,
        );
  }
}

class _StrategyTypeSelector extends StatelessWidget {
  final PasswordStrategyType type;
  final ValueChanged<PasswordStrategyType> onChanged;

  const _StrategyTypeSelector({required this.type, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return SegmentedButton<PasswordStrategyType>(
      style: SegmentedButton.styleFrom(
        backgroundColor: context.colorScheme.surfaceContainerLow,
        selectedBackgroundColor: theme.primary.withValues(alpha: 0.15),
        selectedForegroundColor: theme.primary,
        side: BorderSide(
          color: context.colorScheme.outline.withValues(alpha: 0.1),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      ),
      segments: [
        ButtonSegment(
          value: PasswordStrategyType.random,
          label: _SegmentLabel(
            title: l10n.randomStrategyTitle,
            subtitle: l10n.randomStrategySubtitle,
            icon: LucideIcons.shuffle,
            isSelected: type == PasswordStrategyType.random,
          ),
        ),
        ButtonSegment(
          value: PasswordStrategyType.memorable,
          label: _SegmentLabel(
            title: l10n.memorableStrategyTitle,
            subtitle: l10n.memorableStrategySubtitle,
            icon: LucideIcons.languages,
            isSelected: type == PasswordStrategyType.memorable,
          ),
        ),
      ],
      selected: {type},
      onSelectionChanged: (Set<PasswordStrategyType> newSelection) {
        onChanged(newSelection.first);
      },
      showSelectedIcon: false,
    );
  }
}

class _SegmentLabel extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;

  const _SegmentLabel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.typography;
    final theme = context.theme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.s),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? theme.primary : null,
                ),
              ),
              Text(
                l10n.strategyTypeSubtitle(subtitle),
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: isSelected
                      ? theme.primary.withValues(alpha: 0.7)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
