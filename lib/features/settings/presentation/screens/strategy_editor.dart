import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/strategy_preview/strategy_preview_bloc.dart';
import 'package:passvault/l10n/app_localizations.dart';

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

    return Column(
      children: [
        _PreviewCard(settings: settings),
        const SizedBox(height: AppSpacing.xl),
        _StrategyNameInput(
          controller: _nameController,
          onChanged: (value) =>
              widget.onChanged(settings.copyWith(name: value)),
        ),
        const SizedBox(height: AppSpacing.xl),
        _LengthControl(
          length: settings.length,
          onChanged: (value) =>
              widget.onChanged(settings.copyWith(length: value.round())),
        ),
        const SizedBox(height: AppSpacing.xl),
        _CharacterSetsControl(settings: settings, onChanged: widget.onChanged),
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
    final l10n = context.l10n;
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final textTheme = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: l10n.strategyName),
        const SizedBox(height: AppSpacing.s),
        TextField(
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
            prefixIcon: Icon(
              LucideIcons.tag,
              color: colorScheme.onSurfaceVariant,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _LengthControl extends StatelessWidget {
  final int length;
  final ValueChanged<double> onChanged;

  const _LengthControl({required this.length, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LengthHeader(length: length),
        const SizedBox(height: AppSpacing.s),
        _LengthSlider(length: length, onChanged: onChanged),
      ],
    );
  }
}

class _LengthHeader extends StatelessWidget {
  final int length;
  const _LengthHeader({required this.length});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final textTheme = context.typography;

    return AppSectionHeader(
      title: l10n.passwordLength,
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: theme.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: theme.primary.withValues(alpha: 0.2)),
        ),
        child: Text(
          '$length',
          style: textTheme.labelMedium?.copyWith(
            color: theme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _LengthSlider extends StatelessWidget {
  final int length;
  final ValueChanged<double> onChanged;

  const _LengthSlider({required this.length, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final textTheme = context.typography;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: AppSpacing.m,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              trackHeight: AppDimensions.strategySliderTrackHeight,
              activeTrackColor: theme.primary,
              inactiveTrackColor: theme.outline.withValues(alpha: 0.15),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: AppDimensions.strategySliderThumbRadius,
                elevation: 4,
                pressedElevation: 8,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: AppDimensions.strategySliderOverlayRadius,
              ),
              thumbColor: colorScheme.onPrimary,
              overlayColor: theme.primary.withValues(alpha: 0.15),
              // Ensure tap target size is sufficient
              minThumbSeparation: 0,
            ),
            child: Slider(
              value: length.toDouble(),
              min: 8,
              max: 64,
              divisions: 56,
              onChanged: onChanged,
            ),
          ),
          _SliderLabels(
            l10n: l10n,
            textTheme: textTheme,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

class _SliderLabels extends StatelessWidget {
  final AppLocalizations l10n;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  const _SliderLabels({
    required this.l10n,
    required this.textTheme,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.minLabel,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            l10n.maxLabel,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _CharacterSetsControl extends StatelessWidget {
  final PasswordGenerationStrategy settings;
  final ValueChanged<PasswordGenerationStrategy> onChanged;

  const _CharacterSetsControl({
    required this.settings,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: l10n.characterSets),
        const SizedBox(height: AppSpacing.s),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.l),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: [
              StrategyOptionTile(
                title: l10n.uppercase,
                subtitle: l10n.uppercaseHint,
                icon: LucideIcons.caseUpper,
                value: settings.useUppercase,
                onChanged: (v) => onChanged(settings.copyWith(useUppercase: v)),
              ),
              const _OptionDivider(),
              StrategyOptionTile(
                title: l10n.lowercase,
                subtitle: l10n.lowercaseHint,
                icon: LucideIcons.caseLower,
                value: settings.useLowercase,
                onChanged: (v) => onChanged(settings.copyWith(useLowercase: v)),
              ),
              const _OptionDivider(),
              StrategyOptionTile(
                title: l10n.numbers,
                subtitle: l10n.numbersHint,
                icon: LucideIcons.hash,
                value: settings.useNumbers,
                onChanged: (v) => onChanged(settings.copyWith(useNumbers: v)),
              ),
              const _OptionDivider(),
              StrategyOptionTile(
                title: l10n.specialCharacters,
                subtitle: l10n.specialCharsHint,
                icon: LucideIcons.asterisk,
                value: settings.useSpecialChars,
                onChanged: (v) =>
                    onChanged(settings.copyWith(useSpecialChars: v)),
              ),
              const _OptionDivider(),
              StrategyOptionTile(
                title: l10n.excludeAmbiguous,
                subtitle: l10n.excludeAmbiguousHint,
                icon: LucideIcons.eyeOff,
                value: settings.excludeAmbiguousChars,
                onChanged: (v) =>
                    onChanged(settings.copyWith(excludeAmbiguousChars: v)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A reusable switch tile for strategy options.
///
/// Displays a toggle switch with icon, title, and subtitle for
/// configuring password generation settings.
class StrategyOptionTile extends StatelessWidget {
  /// The main title text.
  final String title;

  /// The subtitle/hint text.
  final String subtitle;

  /// The leading icon.
  final IconData icon;

  /// The current switch value.
  final bool value;

  /// Callback when the switch value changes.
  final ValueChanged<bool> onChanged;

  const StrategyOptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.s,
      ),
      secondary: Icon(
        icon,
        color: value
            ? theme.primary
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        size: AppDimensions.strategyOptionIconSize,
      ),
      title: Text(
        title,
        style: context.typography.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: context.typography.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: theme.primary,
      activeTrackColor: theme.primary.withValues(alpha: 0.2),
      inactiveThumbColor: colorScheme.outline,
      inactiveTrackColor: colorScheme.surfaceContainerHighest,
    );
  }
}

class _OptionDivider extends StatelessWidget {
  const _OptionDivider();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimensions.strategyTileLeadingPadding,
      ),
      child: Divider(
        height: 1,
        color: colorScheme.outline.withValues(alpha: 0.1),
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final PasswordGenerationStrategy settings;

  const _PreviewCard({required this.settings});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<StrategyPreviewBloc>()..add(GeneratePreview(settings)),
      child: _PreviewCardContent(settings: settings),
    );
  }
}

class _PreviewCardContent extends StatelessWidget {
  final PasswordGenerationStrategy settings;

  const _PreviewCardContent({required this.settings});

  @override
  Widget build(BuildContext context) {
    return BlocListener<StrategyPreviewBloc, StrategyPreviewState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == StrategyPreviewStatus.failure) {
          // Ideally show a snackbar or error indication
        }
      },
      child: BlocBuilder<StrategyPreviewBloc, StrategyPreviewState>(
        builder: (context, state) {
          // Trigger generation if settings changed (handled by parent rebuilding this widget)
          // Since this is a stateless widget created by parent's build, we rely on
          // parent rebuilding to recreate/update. However, since we wrapped in BlocProvider
          // inside build(), a rebuild of parent rebuilds this.
          // Actually, creates a NEW BlocProvider each time if key not consistent?
          // No, BlocProvider creates the bloc once. But if 'settings' change,
          // we need to tell the cubit.
          // Better approach: Use Key or hook into didUpdateWidget equivalent via
          // a wrapper or side-effect.
          // Given this is inside a StatelessWidget now, let's use a "Effect" widget
          // or just rely on the fact the parent IS stateful and when it calls this,
          // it passes ALL new settings.

          // Wait, if _PreviewCard is Stateless and wrapped in BlocProvider in its build method,
          // rebuilding _PreviewCard interacts with BlocProvider.
          // If we want to update the cubit when settings change, we need to do it.
          // Simple way: _PreviewCardContent can be StatefulWidget or we use a "Logic" wrapper.
          return _PreviewCardEffect(
            settings: settings,
            child: _PreviewCardView(
              settings: settings,
              state: state,
              onRefresh: () {
                context.read<StrategyPreviewBloc>().add(
                  GeneratePreview(settings),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _PreviewCardEffect extends StatefulWidget {
  final PasswordGenerationStrategy settings;
  final Widget child;
  const _PreviewCardEffect({required this.settings, required this.child});

  @override
  State<_PreviewCardEffect> createState() => _PreviewCardEffectState();
}

class _PreviewCardEffectState extends State<_PreviewCardEffect> {
  @override
  void didUpdateWidget(covariant _PreviewCardEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      context.read<StrategyPreviewBloc>().add(GeneratePreview(widget.settings));
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _PreviewCardView extends StatelessWidget {
  final PasswordGenerationStrategy settings;
  final StrategyPreviewState state;
  final VoidCallback onRefresh;

  const _PreviewCardView({
    required this.settings,
    required this.state,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final colorScheme = context.colorScheme;

    // Trigger update if needed.
    // Since we can't easily do it in build without side effects,
    // let's rely on the parent or a wrapper.
    // NOTE: I will simplify the architecture by making _PreviewCard Stateful
    // but using the Cubit from DI.

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          theme.cardShadow,
          BoxShadow(
            color: theme.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
        border: Border.all(
          color: theme.primary.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.preview.toUpperCase(),
                style: context.typography.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              InkWell(
                onTap: onRefresh,
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Icon(
                    LucideIcons.refreshCw,
                    color: theme.primary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          SelectableText(
            state.password,
            style: context.typography.headlineSmall?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
