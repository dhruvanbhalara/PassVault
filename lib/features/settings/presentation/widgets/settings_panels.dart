import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';

class SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final AppThemeExtension theme;
  final bool isDanger;

  const SettingsGroup({
    super.key,
    required this.title,
    required this.items,
    required this.theme,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final sectionChildren = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      sectionChildren.add(items[i]);
      if (i < items.length - 1) {
        sectionChildren.add(
          const Divider(indent: AppDimensions.listTileDividerIndent, height: 1),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isDanger)
          AppSectionHeader(
            title: title,
            variant: AppSectionHeaderVariant.premium,
          )
        else
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.s,
              top: AppSpacing.l,
              bottom: AppSpacing.s,
            ),
            child: Text(
              title,
              style: context.typography.labelMedium?.copyWith(
                color: theme.error,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        AppCard(
          hasGlow: false,
          padding: EdgeInsets.zero,
          child: Column(children: sectionChildren),
        ),
      ],
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? labelColor;
  final Color? iconColor;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.labelColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? theme.onSurface.withValues(alpha: 0.7),
        size: 20,
      ),
      title: Text(
        label,
        style: context.typography.bodyLarge?.copyWith(color: labelColor),
      ),
      trailing:
          trailing ??
          (onTap != null
              ? const Icon(LucideIcons.chevronRight, size: 16)
              : null),
      onTap: onTap,
    );
  }
}

class ThemePickerSheet extends StatelessWidget {
  final ThemeType currentThemeType;
  final ValueChanged<ThemeType> onThemeSelected;
  final AppLocalizations l10n;

  const ThemePickerSheet({
    super.key,
    required this.currentThemeType,
    required this.onThemeSelected,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.s),
          SizedBox(
            width: AppSpacing.dragHandleWidth,
            height: AppSpacing.dragHandleHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.theme.surfaceDim,
                borderRadius: BorderRadius.circular(AppRadius.s),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          _ThemeOptionTile(
            key: const Key('theme_option_system'),
            icon: LucideIcons.monitor,
            title: l10n.system,
            isSelected: currentThemeType == ThemeType.system,
            selectedColor: colorScheme.primary,
            onTap: () => _select(context, ThemeType.system),
          ),
          _ThemeOptionTile(
            key: const Key('theme_option_light'),
            icon: LucideIcons.sun,
            title: l10n.light,
            isSelected: currentThemeType == ThemeType.light,
            selectedColor: colorScheme.primary,
            onTap: () => _select(context, ThemeType.light),
          ),
          _ThemeOptionTile(
            key: const Key('theme_option_dark'),
            icon: LucideIcons.moon,
            title: l10n.dark,
            isSelected: currentThemeType == ThemeType.dark,
            selectedColor: colorScheme.primary,
            onTap: () => _select(context, ThemeType.dark),
          ),
          _ThemeOptionTile(
            key: const Key('theme_option_amoled'),
            icon: LucideIcons.sparkles,
            title: l10n.amoled,
            isSelected: currentThemeType == ThemeType.amoled,
            selectedColor: colorScheme.primary,
            onTap: () => _select(context, ThemeType.amoled),
          ),
          const SizedBox(height: AppSpacing.m),
        ],
      ),
    );
  }

  void _select(BuildContext context, ThemeType type) {
    onThemeSelected(type);
    Navigator.of(context).pop();
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 24, color: isSelected ? selectedColor : null),
      title: Text(
        title,
        style: isSelected
            ? TextStyle(color: selectedColor, fontWeight: FontWeight.w600)
            : null,
      ),
      trailing: isSelected
          ? Icon(LucideIcons.check, size: 24, color: selectedColor)
          : null,
      onTap: onTap,
    );
  }
}

class LocalePickerSheet extends StatelessWidget {
  final Locale? selectedLocale;
  final ValueChanged<Locale> onLocaleSelected;
  final VoidCallback onSystemLocaleSelected;
  final AppLocalizations l10n;

  const LocalePickerSheet({
    super.key,
    required this.selectedLocale,
    required this.onLocaleSelected,
    required this.onSystemLocaleSelected,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final locales = AppLocalizations.supportedLocales;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.s),
          SizedBox(
            width: AppSpacing.dragHandleWidth,
            height: AppSpacing.dragHandleHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.theme.surfaceDim,
                borderRadius: BorderRadius.circular(AppRadius.s),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          ListTile(
            key: const Key('locale_option_system'),
            title: Text(l10n.system),
            trailing: _isSameLocale(selectedLocale, null)
                ? Icon(LucideIcons.check, size: 24, color: colorScheme.primary)
                : null,
            onTap: () {
              onSystemLocaleSelected();
              Navigator.of(context).pop();
            },
          ),
          ...locales.map(
            (locale) => ListTile(
              key: Key('locale_option_${locale.languageCode}'),
              title: Text(_localeName(locale)),
              trailing: _isSameLocale(selectedLocale, locale)
                  ? Icon(
                      LucideIcons.check,
                      size: 24,
                      color: colorScheme.primary,
                    )
                  : null,
              onTap: () {
                onLocaleSelected(locale);
                Navigator.of(context).pop();
              },
            ),
          ),
          const SizedBox(height: AppSpacing.m),
        ],
      ),
    );
  }

  String _localeName(Locale locale) {
    return switch (locale.languageCode) {
      'en' => l10n.english,
      _ => locale.toLanguageTag(),
    };
  }

  bool _isSameLocale(Locale? a, Locale? b) {
    if (a == null || b == null) return a == b;
    return a.languageCode == b.languageCode && a.countryCode == b.countryCode;
  }
}
