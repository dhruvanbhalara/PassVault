import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/l10n/app_localizations.dart';

class StrategyLengthControl extends StatelessWidget {
  final int length;
  final ValueChanged<double> onChanged;

  const StrategyLengthControl({
    super.key,
    required this.length,
    required this.onChanged,
  });

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
              minThumbSeparation: 0,
            ),
            child: Slider(
              value: length.toDouble(),
              min: 16,
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
