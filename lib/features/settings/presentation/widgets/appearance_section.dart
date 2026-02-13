import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';

/// Section for appearance settings like theme.
class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final themeType = switch (state) {
          ThemeLoaded(:final themeType) => themeType,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionHeader(
              title: l10n.appearance,
              variant: AppSectionHeaderVariant.premium,
            ),
            Card(
              child: ListTile(
                key: const Key('settings_theme_tile'),
                leading: const Icon(LucideIcons.palette, size: 24),
                title: Text(l10n.theme),
                subtitle: Text(_getThemeName(themeType, l10n)),
                trailing: const Icon(LucideIcons.chevronRight, size: 24),
                onTap: () => _showThemePicker(
                  context,
                  context.read<ThemeBloc>(),
                  themeType,
                  l10n,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getThemeName(ThemeType type, AppLocalizations l10n) {
    switch (type) {
      case ThemeType.system:
        return l10n.system;
      case ThemeType.light:
        return l10n.light;
      case ThemeType.dark:
        return l10n.dark;
      case ThemeType.amoled:
        return l10n.amoled;
    }
  }

  void _showThemePicker(
    BuildContext context,
    ThemeBloc bloc,
    ThemeType currentTheme,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) =>
          _ThemePickerSheet(bloc: bloc, currentTheme: currentTheme, l10n: l10n),
    );
  }
}

class _ThemePickerSheet extends StatelessWidget {
  final ThemeBloc bloc;
  final ThemeType currentTheme;
  final AppLocalizations l10n;

  const _ThemePickerSheet({
    required this.bloc,
    required this.currentTheme,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.theme,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          _ThemeOptionTile(
            key: const Key('theme_option_system'),
            icon: LucideIcons.monitor,
            title: l10n.system,
            isSelected: currentTheme == ThemeType.system,
            selectedColor: colorScheme.primary,
            onTap: () {
              bloc.add(const ThemeChanged(ThemeType.system));
              Navigator.pop(context);
            },
          ),
          _ThemeOptionTile(
            key: const Key('theme_option_light'),
            icon: LucideIcons.sun,
            title: l10n.light,
            isSelected: currentTheme == ThemeType.light,
            selectedColor: colorScheme.primary,
            onTap: () {
              bloc.add(const ThemeChanged(ThemeType.light));
              Navigator.pop(context);
            },
          ),
          _ThemeOptionTile(
            key: const Key('theme_option_dark'),
            icon: LucideIcons.moon,
            title: l10n.dark,
            isSelected: currentTheme == ThemeType.dark,
            selectedColor: colorScheme.primary,
            onTap: () {
              bloc.add(const ThemeChanged(ThemeType.dark));
              Navigator.pop(context);
            },
          ),
          _ThemeOptionTile(
            key: const Key('theme_option_amoled'),
            icon: LucideIcons.sparkles,
            title: l10n.amoled,
            isSelected: currentTheme == ThemeType.amoled,
            selectedColor: colorScheme.primary,
            onTap: () {
              bloc.add(const ThemeChanged(ThemeType.amoled));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: AppSpacing.m),
        ],
      ),
    );
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
