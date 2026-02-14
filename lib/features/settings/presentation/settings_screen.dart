import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_state.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/locale/locale_cubit.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:passvault/features/settings/presentation/widgets/password_protected_dialog.dart';
import 'package:passvault/features/settings/presentation/widgets/settings_panels.dart';

/// Screen for managing application settings, security, and data.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final themeState = context.watch<ThemeBloc>().state;
    final currentThemeType = switch (themeState) {
      ThemeLoaded(:final themeType) => themeType,
    };
    final localeOverride = context.watch<LocaleCubit>().state;
    final currentLocale = localeOverride ?? Localizations.localeOf(context);

    return BlocListener<ImportExportBloc, ImportExportState>(
      listener: (context, state) {
        if (state is ImportSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.importSuccess)));
          context.read<ImportExportBloc>().add(const ResetMigrationStatus());
        } else if (state is DuplicatesDetected) {
          context.push(AppRoutes.resolveDuplicates, extra: state.duplicates);
          context.read<ImportExportBloc>().add(const ResetMigrationStatus());
        } else if (state is ImportEncryptedFileSelected) {
          showDialog(
            context: context,
            builder: (dialogContext) => PasswordProtectedDialog(
              bloc: context.read<ImportExportBloc>(),
              isExport: false,
              filePath: state.filePath,
            ),
          );
        } else if (state is ClearDatabaseSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.databaseCleared)));
          context.read<ImportExportBloc>().add(const ResetMigrationStatus());
        } else if (state is ImportExportFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.error,
            ),
          );
          context.read<ImportExportBloc>().add(const ResetMigrationStatus());
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              centerTitle: true,
              title: Text(l10n.settings),
              floating: true,
              pinned: true,
              scrolledUnderElevation: 0,
              backgroundColor: theme.background.withValues(alpha: 0),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.l),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SettingsGroup(
                    title: l10n.security,
                    theme: theme,
                    items: [
                      SettingsItem(
                        key: const Key('settings_password_gen_tile'),
                        icon: LucideIcons.keyRound,
                        label: l10n.passwordGeneration,
                        onTap: () => context.push(AppRoutes.passwordGeneration),
                      ),
                      BlocBuilder<SettingsBloc, SettingsState>(
                        builder: (context, state) {
                          return switch (state) {
                            SettingsInitial(:final useBiometrics) ||
                            SettingsLoading(:final useBiometrics) ||
                            SettingsLoaded(:final useBiometrics) ||
                            SettingsFailure(
                              :final useBiometrics,
                            ) => SwitchListTile(
                              key: const Key('settings_biometric_switch'),
                              secondary: const Icon(LucideIcons.shieldCheck),
                              title: Text(l10n.useBiometrics),
                              value: useBiometrics,
                              onChanged: (value) {
                                context.read<SettingsBloc>().add(
                                  ToggleBiometrics(value),
                                );
                              },
                            ),
                          };
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.l),
                  // Appearance Section
                  SettingsGroup(
                    title: l10n.appearance,
                    theme: theme,
                    items: [
                      SettingsItem(
                        key: const Key('settings_theme_tile'),
                        icon: LucideIcons.moon,
                        label: l10n.theme,
                        trailing: Text(_getThemeName(currentThemeType, l10n)),
                        onTap: () => _showThemePicker(
                          context,
                          currentThemeType: currentThemeType,
                          l10n: l10n,
                        ),
                      ),
                      SettingsItem(
                        key: const Key('settings_language_tile'),
                        icon: LucideIcons.languages,
                        label: l10n.language,
                        trailing: Text(_localeDisplayName(currentLocale, l10n)),
                        onTap: () => _showLanguagePicker(
                          context,
                          selectedLocale: localeOverride,
                          l10n: l10n,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.l),
                  // Data Section
                  SettingsGroup(
                    title: l10n.dataManagement,
                    theme: theme,
                    items: [
                      SettingsItem(
                        key: const Key('settings_import_tile'),
                        icon: LucideIcons.download,
                        label: l10n.importData,
                        onTap: () => context.read<ImportExportBloc>().add(
                          const PrepareImportFromFileEvent(),
                        ),
                      ),
                      SettingsItem(
                        key: const Key('settings_export_tile'),
                        icon: LucideIcons.upload,
                        label: l10n.exportVault,
                        onTap: () => context.push(AppRoutes.exportVault),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Danger Zone
                  SettingsGroup(
                    title: l10n.dangerZone,
                    theme: theme,
                    isDanger: true,
                    items: [
                      SettingsItem(
                        key: const Key('settings_clear_db_tile'),
                        icon: LucideIcons.trash2,
                        label: l10n.clearDatabase,
                        labelColor: theme.error,
                        iconColor: theme.error,
                        onTap: () => _showClearDatabaseDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeName(ThemeType type, AppLocalizations l10n) {
    return switch (type) {
      ThemeType.system => l10n.system,
      ThemeType.light => l10n.light,
      ThemeType.dark => l10n.dark,
      ThemeType.amoled => l10n.amoled,
    };
  }

  String _localeDisplayName(Locale locale, AppLocalizations l10n) {
    return switch (locale.languageCode) {
      'en' => l10n.english,
      _ => locale.toLanguageTag(),
    };
  }

  void _showThemePicker(
    BuildContext context, {
    required ThemeType currentThemeType,
    required AppLocalizations l10n,
  }) {
    final themeBloc = context.read<ThemeBloc>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => ThemePickerSheet(
        currentThemeType: currentThemeType,
        onThemeSelected: (themeType) => themeBloc.add(ThemeChanged(themeType)),
        l10n: l10n,
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context, {
    required Locale? selectedLocale,
    required AppLocalizations l10n,
  }) {
    final localeCubit = context.read<LocaleCubit>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => LocalePickerSheet(
        selectedLocale: selectedLocale,
        onLocaleSelected: localeCubit.setLocale,
        onSystemLocaleSelected: localeCubit.setSystemLocale,
        l10n: l10n,
      ),
    );
  }

  void _showClearDatabaseDialog(BuildContext context) {
    final bloc = context.read<ImportExportBloc>();
    final l10n = context.l10n;
    final theme = context.theme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.clearDatabaseTitle),
        content: Text(l10n.clearDatabaseMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel, style: TextStyle(color: theme.onSurface)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              bloc.add(const ClearDatabaseEvent());
            },
            style: TextButton.styleFrom(foregroundColor: theme.error),
            child: Text(l10n.clearAll),
          ),
        ],
      ),
    );
  }
}
