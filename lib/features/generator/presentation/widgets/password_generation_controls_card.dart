import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
                          Text(
                            length.toString(),
                            style: context.typography.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Slider(
                        value: length.toDouble(),
                        min: 16,
                        max: 64,
                        divisions: 48, // (64 - 16)
                        label: length.toString(),
                        onChanged: (value) => onLengthChanged(value.round()),
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
                          Text(
                            strategy.wordCount.toString(),
                            style: context.typography.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Slider(
                        value: strategy.wordCount.toDouble(),
                        min: 3,
                        max: 10,
                        divisions: 7, // (10 - 3)
                        label: strategy.wordCount.toString(),
                        onChanged: (value) => onWordCountChanged(value.round()),
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

const List<String> _separatorOptions = ['-', '_', '.', ' ', ''];
