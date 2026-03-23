import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/generator/presentation/widgets/generator_control_widgets.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/domain/entities/password_strategy_type.dart';

class PasswordGenerationControlsCard extends StatelessWidget {
  final PasswordGenerationStrategy strategy;
  final String controlsPrefix;
  final ValueChanged<int> onLengthChanged;
  final ValueChanged<bool> onUppercaseChanged;
  final ValueChanged<bool> onLowercaseChanged;
  final ValueChanged<bool> onNumbersChanged;
  final ValueChanged<bool> onSymbolsChanged;
  final ValueChanged<bool> onExcludeAmbiguousChanged;
  final ValueChanged<int> onWordCountChanged;
  final ValueChanged<String> onSeparatorChanged;

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
    required this.onWordCountChanged,
    required this.onSeparatorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final length = strategy.length;
    final isRandom = strategy.type == PasswordStrategyType.random;

    return AppCard(
      hasGlow: context.isAmoled,
      padding: const EdgeInsets.all(AppSpacing.l),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child:
            Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isRandom) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.lengthLabel,
                              style: context.typography.labelMedium,
                            ),
                          ),
                          _CountStepper(
                            decreaseKey: Key(
                              '${controlsPrefix}_length_decrease',
                            ),
                            increaseKey: Key(
                              '${controlsPrefix}_length_increase',
                            ),
                            badgeKey: Key('${controlsPrefix}_length_badge'),
                            value: length,
                            min: 16,
                            max: 64,
                            onChanged: onLengthChanged,
                          ),
                        ],
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
                    ] else ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.wordCountLabel,
                              style: context.typography.labelMedium,
                            ),
                          ),
                          _CountStepper(
                            decreaseKey: Key(
                              '${controlsPrefix}_word_count_decrease',
                            ),
                            increaseKey: Key(
                              '${controlsPrefix}_word_count_increase',
                            ),
                            badgeKey: Key('${controlsPrefix}_word_count_badge'),
                            value: strategy.wordCount,
                            min: 3,
                            max: 10,
                            onChanged: onWordCountChanged,
                          ),
                        ],
                      ),
                      const Divider(height: AppSpacing.l),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.separatorLabel,
                              style: context.typography.labelMedium,
                            ),
                          ),
                          DropdownButton<String>(
                            value: strategy.separator,
                            items: _separatorOptions.map((separator) {
                              return DropdownMenuItem(
                                value: separator,
                                child: Text(
                                  separator.isEmpty
                                      ? l10n.separatorNone
                                      : separator,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                onSeparatorChanged(value);
                              }
                            },
                          ),
                        ],
                      ),
                      const Divider(height: AppSpacing.l),
                      GeneratorToggleTile(
                        key: Key(
                          '${controlsPrefix}_memorable_uppercase_toggle',
                        ),
                        label: l10n.uppercaseLabel,
                        value: strategy.useUppercase,
                        onChanged: onUppercaseChanged,
                      ),
                      GeneratorToggleTile(
                        key: Key(
                          '${controlsPrefix}_memorable_lowercase_toggle',
                        ),
                        label: l10n.lowercaseLabel,
                        value: strategy.useLowercase,
                        onChanged: onLowercaseChanged,
                      ),
                    ],
                  ],
                )
                .animate()
                .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                .slideX(begin: 0.05, end: 0, curve: Curves.easeOutQuad),
      ),
    );
  }
}

class _CountStepper extends StatelessWidget {
  final Key decreaseKey;
  final Key increaseKey;
  final Key badgeKey;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _CountStepper({
    required this.decreaseKey,
    required this.increaseKey,
    required this.badgeKey,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.theme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.m),
      ),
      child: Row(
        children: [
          LengthStepperButton(
            key: decreaseKey,
            icon: LucideIcons.minus,
            isEnabled: value > min,
            onTap: () => onChanged(value - 1),
          ),
          const SizedBox(width: AppSpacing.xs),
          Container(
            key: badgeKey,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: context.theme.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              value.toString(),
              style: context.typography.labelMedium?.copyWith(
                color: context.theme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          LengthStepperButton(
            key: increaseKey,
            icon: LucideIcons.plus,
            isEnabled: value < max,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

const List<String> _separatorOptions = ['-', '_', '.', ' ', ''];
