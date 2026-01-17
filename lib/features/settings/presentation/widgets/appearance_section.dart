import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_cubit.dart';
import 'package:passvault/features/settings/presentation/widgets/settings_shared_widgets.dart';
import 'package:passvault/l10n/app_localizations.dart';

/// Section for appearance settings like theme.
class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeCubit = context.watch<ThemeCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.appearance),
        Card(
          child: ListTile(
            key: const Key('settings_theme_tile'),
            leading: const Icon(LucideIcons.palette),
            title: Text(l10n.theme),
            subtitle: Text(_getThemeName(themeCubit.state.themeType, l10n)),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () => _showThemePicker(context, themeCubit, l10n),
          ),
        ),
      ],
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
    ThemeCubit cubit,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => _ThemePickerSheet(cubit: cubit, l10n: l10n),
    );
  }
}

class _ThemePickerSheet extends StatelessWidget {
  final ThemeCubit cubit;
  final AppLocalizations l10n;

  const _ThemePickerSheet({required this.cubit, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.s),
          SizedBox(
            width: AppDimensions.dragHandleWidth,
            height: AppDimensions.dragHandleHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.theme.surfaceDim,
                borderRadius: BorderRadius.circular(AppRadius.s),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          ListTile(
            key: const Key('theme_option_system'),
            leading: const Icon(LucideIcons.monitor),
            title: Text(l10n.system),
            onTap: () {
              cubit.setTheme(ThemeType.system);
              Navigator.pop(context);
            },
          ),
          ListTile(
            key: const Key('theme_option_light'),
            leading: const Icon(LucideIcons.sun),
            title: Text(l10n.light),
            onTap: () {
              cubit.setTheme(ThemeType.light);
              Navigator.pop(context);
            },
          ),
          ListTile(
            key: const Key('theme_option_dark'),
            leading: const Icon(LucideIcons.moon),
            title: Text(l10n.dark),
            onTap: () {
              cubit.setTheme(ThemeType.dark);
              Navigator.pop(context);
            },
          ),
          ListTile(
            key: const Key('theme_option_amoled'),
            leading: const Icon(LucideIcons.sparkles),
            title: Text(l10n.amoled),
            onTap: () {
              cubit.setTheme(ThemeType.amoled);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: AppSpacing.m),
        ],
      ),
    );
  }
}
