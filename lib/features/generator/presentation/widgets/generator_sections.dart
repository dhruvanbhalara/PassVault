import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/generator/presentation/bloc/generator_bloc.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

class GeneratorGeneratedPasswordCard extends StatelessWidget {
  final GeneratorLoaded state;

  const GeneratorGeneratedPasswordCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final typography = context.typography;
    final l10n = context.l10n;

    return AppCard(
      hasGlow: false,
      padding: const EdgeInsets.all(AppSpacing.l),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 136, maxHeight: 168),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SelectableText(
                    state.generatedPassword.isEmpty
                        ? l10n.hintPassword
                        : state.generatedPassword,
                    maxLines: 2,
                    style: theme.passwordText.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: theme.primary,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                IconButton(
                  key: const Key('generator_copy_icon_button'),
                  tooltip: l10n.copyPassword,
                  onPressed: state.generatedPassword.isEmpty
                      ? null
                      : () => _copyPassword(
                          context,
                          password: state.generatedPassword,
                        ),
                  icon: const Icon(LucideIcons.copy),
                ),
              ],
            ),
            PasswordStrengthIndicator(
              strength: state.strength,
              showLabel: true,
            ),
            Text(
              _strengthText(state.strength, l10n),
              style: typography.labelMedium?.copyWith(
                color: _strengthColor(state.strength, theme),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyPassword(
    BuildContext context, {
    required String password,
  }) async {
    await Clipboard.setData(ClipboardData(text: password));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.passwordCopied)));
  }

  String _strengthText(double strength, AppLocalizations l10n) {
    if (strength <= 0.15) return l10n.strengthVeryWeak;
    if (strength <= 0.35) return l10n.strengthWeak;
    if (strength <= 0.55) return l10n.strengthFair;
    if (strength <= 0.75) return l10n.strengthGood;
    if (strength <= 0.90) return l10n.strengthStrong;
    return l10n.strengthVeryStrong;
  }

  Color _strengthColor(double strength, AppThemeExtension theme) {
    if (strength <= 0.15) return theme.strengthVeryWeak;
    if (strength <= 0.35) return theme.strengthWeak;
    if (strength <= 0.55) return theme.strengthFair;
    if (strength <= 0.75) return theme.strengthGood;
    if (strength <= 0.90) return theme.strengthStrong;
    return theme.strengthVeryStrong;
  }
}

class GeneratorControlsCard extends StatelessWidget {
  final GeneratorLoaded state;

  const GeneratorControlsCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return PasswordGenerationControlsCard(
      strategy: state.strategy,
      controlsPrefix: 'generator',
      onLengthChanged: (length) =>
          context.read<GeneratorBloc>().add(GeneratorLengthChanged(length)),
      onUppercaseChanged: (value) =>
          context.read<GeneratorBloc>().add(GeneratorUppercaseToggled(value)),
      onLowercaseChanged: (value) =>
          context.read<GeneratorBloc>().add(GeneratorLowercaseToggled(value)),
      onNumbersChanged: (value) =>
          context.read<GeneratorBloc>().add(GeneratorNumbersToggled(value)),
      onSymbolsChanged: (value) =>
          context.read<GeneratorBloc>().add(GeneratorSymbolsToggled(value)),
      onExcludeAmbiguousChanged: (value) => context.read<GeneratorBloc>().add(
        GeneratorExcludeAmbiguousToggled(value),
      ),
    );
  }
}

class PasswordGenerationControlsCard extends StatelessWidget {
  final PasswordGenerationStrategy strategy;
  final String controlsPrefix;
  final ValueChanged<int> onLengthChanged;
  final ValueChanged<bool> onUppercaseChanged;
  final ValueChanged<bool> onLowercaseChanged;
  final ValueChanged<bool> onNumbersChanged;
  final ValueChanged<bool> onSymbolsChanged;
  final ValueChanged<bool> onExcludeAmbiguousChanged;

  const PasswordGenerationControlsCard({
    super.key,
    required this.strategy,
    required this.controlsPrefix,
    required this.onLengthChanged,
    required this.onUppercaseChanged,
    required this.onLowercaseChanged,
    required this.onNumbersChanged,
    required this.onSymbolsChanged,
    required this.onExcludeAmbiguousChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final length = strategy.length;
    final canDecrease = length > 16;
    final canIncrease = length < 64;

    return AppCard(
      hasGlow: false,
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.passwordLength,
                  style: context.typography.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              LengthStepperButton(
                key: Key('${controlsPrefix}_length_decrease'),
                icon: LucideIcons.minus,
                isEnabled: canDecrease,
                onTap: () => onLengthChanged(length - 1),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                key: Key('${controlsPrefix}_length_badge'),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: context.theme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  length.toString(),
                  style: context.typography.labelMedium?.copyWith(
                    color: context.theme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              LengthStepperButton(
                key: Key('${controlsPrefix}_length_increase'),
                icon: LucideIcons.plus,
                isEnabled: canIncrease,
                onTap: () => onLengthChanged(length + 1),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          Slider(
            key: Key('${controlsPrefix}_length_slider'),
            value: length.toDouble(),
            min: 16,
            max: 64,
            divisions: 48,
            label: length.toString(),
            onChanged: (value) => onLengthChanged(value.toInt()),
          ),
          const Divider(height: AppSpacing.l),
          GeneratorToggleTile(
            key: Key('${controlsPrefix}_uppercase_toggle'),
            label: l10n.uppercaseLabel,
            value: strategy.useUppercase,
            onChanged: onUppercaseChanged,
          ),
          GeneratorToggleTile(
            key: Key('${controlsPrefix}_lowercase_toggle'),
            label: l10n.lowercaseLabel,
            value: strategy.useLowercase,
            onChanged: onLowercaseChanged,
          ),
          GeneratorToggleTile(
            key: Key('${controlsPrefix}_numbers_toggle'),
            label: l10n.numbersLabel,
            value: strategy.useNumbers,
            onChanged: onNumbersChanged,
          ),
          GeneratorToggleTile(
            key: Key('${controlsPrefix}_symbols_toggle'),
            label: l10n.symbolsLabel,
            value: strategy.useSpecialChars,
            onChanged: onSymbolsChanged,
          ),
          GeneratorToggleTile(
            key: Key('${controlsPrefix}_exclude_ambiguous_toggle'),
            label: l10n.excludeAmbiguous,
            subtitle: l10n.excludeAmbiguousHint,
            value: strategy.excludeAmbiguousChars,
            onChanged: onExcludeAmbiguousChanged,
          ),
        ],
      ),
    );
  }
}

class LengthStepperButton extends StatelessWidget {
  final IconData icon;
  final bool isEnabled;
  final VoidCallback onTap;

  const LengthStepperButton({
    super.key,
    required this.icon,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isEnabled ? onTap : null,
      icon: Icon(icon, size: AppIconSize.m),
      visualDensity: VisualDensity.compact,
    );
  }
}

class GeneratorToggleTile extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const GeneratorToggleTile({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label),
      subtitle: subtitle == null ? null : Text(subtitle!),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      dense: true,
      visualDensity: const VisualDensity(vertical: -2),
    );
  }
}
