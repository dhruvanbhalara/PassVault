import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';

class PasswordLengthCard extends StatelessWidget {
  final PasswordGenerationSettings settings;

  const PasswordLengthCard({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          children: [
            _LengthHeader(length: settings.length),
            const SizedBox(height: AppSpacing.m),
            _LengthSlider(settings: settings),
            const _LengthLabels(),
          ],
        ),
      ),
    );
  }
}

class _LengthHeader extends StatelessWidget {
  final int length;
  const _LengthHeader({required this.length});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _IconBox(icon: LucideIcons.ruler, color: theme.primary),
            const SizedBox(width: AppSpacing.m),
            Text(
              context.l10n.passwordLength,
              style: context.typography.titleMedium,
            ),
          ],
        ),
        _Badge(text: '$length'),
      ],
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _IconBox({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Icon(icon, color: color, size: AppIconSize.s),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.primary,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          text,
          style: context.typography.titleMedium?.copyWith(
            color: theme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _LengthSlider extends StatelessWidget {
  final PasswordGenerationSettings settings;
  const _LengthSlider({required this.settings});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: AppDimensions.sliderTrackHeight,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: AppDimensions.sliderThumbRadius,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: AppDimensions.sliderOverlayRadius,
        ),
      ),
      child: Slider(
        value: settings.length.toDouble(),
        min: 8,
        max: 64,
        divisions: 56,
        onChanged: (value) {
          context.read<SettingsBloc>().add(
            UpdatePasswordSettings(settings.copyWith(length: value.round())),
          );
        },
      ),
    );
  }
}

class _LengthLabels extends StatelessWidget {
  const _LengthLabels();

  @override
  Widget build(BuildContext context) {
    final style = context.typography.bodySmall?.copyWith(
      color: context.theme.outline,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('8', style: style),
          Text('64', style: style),
        ],
      ),
    );
  }
}
