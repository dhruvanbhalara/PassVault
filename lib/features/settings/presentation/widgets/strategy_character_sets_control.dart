import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

class StrategyCharacterSetsControl extends StatelessWidget {
  final PasswordGenerationStrategy settings;
  final ValueChanged<PasswordGenerationStrategy> onChanged;

  const StrategyCharacterSetsControl({
    super.key,
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
