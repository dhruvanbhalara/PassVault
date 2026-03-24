import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/locale/locale_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/settings/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';
import 'package:passvault/features/settings/presentation/settings_screen_helpers.dart';
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
    final localeOverride = context.watch<LocaleBloc>().state.locale;
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
        } else if (state is DuplicatesResolved) {
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
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.l,
                    AppSpacing.m,
                    AppSpacing.l,
                    AppSpacing.s,
                  ),
                  child: PageHeader(title: l10n.settings),
                ),
              ),
            ),

            // Security Section
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              sliver: SliverToBoxAdapter(
                child: SettingsGroup(
                  title: l10n.security,
                  theme: theme,
                  items: [
                    SettingsItem(
                      key: const Key('settings_password_gen_tile'),
                      icon: LucideIcons.keyRound,
                      label: l10n.strategy,
                      onTap: () => context.push(AppRoutes.strategy),
                    ),
                    BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        final useBiometrics = state.useBiometrics;
                        return SwitchListTile(
                          key: const Key('settings_biometric_switch'),
                          secondary: const Icon(LucideIcons.shieldCheck),
                          title: Text(l10n.useBiometrics),
                          value: useBiometrics,
                          onChanged: (value) {
                            context.read<SettingsBloc>().add(
                              ToggleBiometrics(value),
                            );
                          },
                        );
                      },
                    ),
                    BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        return SwitchListTile(
                          key: const Key('settings_screen_privacy_switch'),
                          secondary: const Icon(LucideIcons.eyeOff),
                          title: Text(l10n.screenPrivacy),
                          subtitle: Text(l10n.screenPrivacySubtitle),
                          value: state.useScreenPrivacy,
                          onChanged: (value) {
                            context.read<SettingsBloc>().add(
                              ToggleScreenPrivacy(value),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Spacing
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.l)),

            // Appearance Section
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              sliver: SliverToBoxAdapter(
                child: SettingsGroup(
                  title: l10n.appearance,
                  theme: theme,
                  items: [
                    SettingsItem(
                      key: const Key('settings_theme_tile'),
                      icon: LucideIcons.moon,
                      label: l10n.theme,
                      trailing: Text(themeDisplayName(currentThemeType, l10n)),
                      onTap: () => showThemePickerSheet(
                        context,
                        currentThemeType: currentThemeType,
                        l10n: l10n,
                      ),
                    ),
                    SettingsItem(
                      key: const Key('settings_language_tile'),
                      icon: LucideIcons.languages,
                      label: l10n.language,
                      trailing: Text(localeDisplayName(currentLocale, l10n)),
                      onTap: () => showLanguagePickerSheet(
                        context,
                        selectedLocale: localeOverride,
                        l10n: l10n,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Spacing
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.l)),

            // Data Management Section
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              sliver: SliverToBoxAdapter(
                child: SettingsGroup(
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
              ),
            ),

            // Spacing
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

            // Danger Zone Section
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              sliver: SliverToBoxAdapter(
                child: SettingsGroup(
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
                      onTap: () => showClearDatabaseDialog(context),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Padding (reserve space for floating nav bar + safe area)
            SliverToBoxAdapter(
              child: SizedBox(
                height:
                    AppSpacing.xxl +
                    kBottomNavigationBarHeight +
                    MediaQuery.paddingOf(context).bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
