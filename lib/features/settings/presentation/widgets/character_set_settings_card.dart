import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';

class CharacterSetSettingsCard extends StatelessWidget {
  final PasswordGenerationSettings settings;

  const CharacterSetSettingsCard({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      child: Column(
        children: [
          _SettingToggle(
            icon: LucideIcons.caseUpper,
            title: l10n.uppercase,
            subtitle: l10n.uppercaseHint,
            value: settings.useUppercase,
            onChanged: (value) =>
                _update(context, settings.copyWith(useUppercase: value)),
          ),
          const _ListDivider(),
          _SettingToggle(
            icon: LucideIcons.caseLower,
            title: l10n.lowercase,
            subtitle: l10n.lowercaseHint,
            value: settings.useLowercase,
            onChanged: (value) =>
                _update(context, settings.copyWith(useLowercase: value)),
          ),
          const _ListDivider(),
          _SettingToggle(
            icon: LucideIcons.hash,
            title: l10n.numbers,
            subtitle: l10n.numbersHint,
            value: settings.useNumbers,
            onChanged: (value) =>
                _update(context, settings.copyWith(useNumbers: value)),
          ),
          const _ListDivider(),
          _SettingToggle(
            icon: LucideIcons.asterisk,
            title: l10n.specialCharacters,
            subtitle: l10n.specialCharsHint,
            value: settings.useSpecialChars,
            onChanged: (value) =>
                _update(context, settings.copyWith(useSpecialChars: value)),
          ),
          const _ListDivider(indent: 56),
          _SettingToggle(
            icon: LucideIcons.eyeOff,
            title: l10n.excludeAmbiguous,
            subtitle: l10n.excludeAmbiguousHint,
            value: settings.excludeAmbiguousChars,
            onChanged: (value) => _update(
              context,
              settings.copyWith(excludeAmbiguousChars: value),
            ),
          ),
        ],
      ),
    );
  }

  void _update(BuildContext context, PasswordGenerationSettings newSettings) {
    context.read<SettingsBloc>().add(UpdatePasswordSettings(newSettings));
  }
}

class _SettingToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle, style: context.typography.bodySmall),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _ListDivider extends StatelessWidget {
  final double indent;
  const _ListDivider({this.indent = AppDimensions.listTileDividerIndent});

  @override
  Widget build(BuildContext context) {
    return Divider(indent: indent, height: 1);
  }
}
