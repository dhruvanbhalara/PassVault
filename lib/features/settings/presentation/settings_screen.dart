import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/core/theme/app_dimensions.dart';
import 'package:passvault/core/theme/app_theme_extension.dart';
import 'package:passvault/core/theme/bloc/theme_cubit.dart';
import 'package:passvault/features/home/presentation/bloc/password_bloc.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/screens/password_generation_settings_screen.dart';
import 'package:passvault/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsBloc>()..add(LoadSettings()),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeCubit = context.watch<ThemeCubit>();
    final settingsBloc = context.read<SettingsBloc>();

    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state.status == SettingsStatus.success &&
            state.success != SettingsSuccess.none) {
          String message = '';
          switch (state.success) {
            case SettingsSuccess.exportSuccess:
              message = l10n.exportSuccess;
            case SettingsSuccess.importSuccess:
              message = l10n.importSuccess;
              // Refresh passwords list after import
              getIt<PasswordBloc>().add(LoadPasswords());
            case SettingsSuccess.none:
              break;
          }

          if (message.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
        } else if (state.status == SettingsStatus.failure &&
            state.error != SettingsError.none) {
          String message = l10n.errorOccurred;
          switch (state.error) {
            case SettingsError.noDataToExport:
              message = l10n.noDataToExport;
            case SettingsError.importFailed:
              message = l10n.importFailed;
            case SettingsError.wrongPassword:
              message = l10n.wrongPassword;
            case SettingsError.unknown:
              message = l10n.errorOccurred;
            case SettingsError.none:
              break;
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.settings)),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceM),
          children: [
            _SectionHeader(title: l10n.appearance),
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
            const SizedBox(height: AppDimensions.spaceXL),
            _SectionHeader(title: l10n.security),
            Card(
              child: Column(
                children: [
                  ListTile(
                    key: const Key('settings_password_gen_tile'),
                    leading: const Icon(LucideIcons.keyRound),
                    title: Text(l10n.passwordGeneration),
                    trailing: const Icon(LucideIcons.chevronRight),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PasswordGenerationSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(indent: 56, height: 1),
                  BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      return SwitchListTile(
                        key: const Key('settings_biometric_switch'),
                        secondary: const Icon(LucideIcons.shieldCheck),
                        title: Text(l10n.useBiometrics),
                        value: state.useBiometrics,
                        onChanged: (value) {
                          settingsBloc.add(ToggleBiometrics(value));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXL),
            _SectionHeader(title: l10n.dataManagement),
            Card(
              child: Column(
                children: [
                  ListTile(
                    key: const Key('settings_export_tile'),
                    leading: const Icon(LucideIcons.upload),
                    title: Text(l10n.exportData),
                    trailing: const Icon(LucideIcons.chevronRight),
                    onTap: () => _showExportPicker(context, settingsBloc),
                  ),
                  const Divider(indent: 56, endIndent: 16, height: 1),
                  ListTile(
                    key: const Key('settings_import_tile'),
                    leading: const Icon(LucideIcons.download),
                    title: Text(l10n.importData),
                    trailing: const Icon(LucideIcons.chevronRight),
                    onTap: () => _showImportPicker(context, settingsBloc),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXXL),
          ],
        ),
      ),
    );
  }

  void _showExportPicker(BuildContext context, SettingsBloc bloc) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = context.colors;
    final textTheme = context.typography;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
                  decoration: BoxDecoration(
                    color: colors.surfaceDim,
                    borderRadius: AppDimensions.borderRadiusS,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.exportData,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceM),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                  child: Icon(
                    LucideIcons.braces,
                    color: colors.primary,
                    size: 20,
                  ),
                ),
                title: Text(l10n.exportJson),
                subtitle: Text(
                  l10n.jsonBackupFormat,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Icon(
                  LucideIcons.chevronRight,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  bloc.add(const ExportData(isJson: true));
                  Navigator.pop(context);
                },
              ),
              Divider(
                indent: 72,
                endIndent: 16,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                  child: Icon(
                    LucideIcons.table,
                    color: theme.colorScheme.onSecondaryContainer,
                    size: 20,
                  ),
                ),
                title: Text(l10n.exportCsv),
                subtitle: Text(
                  l10n.csvSpreadsheetFormat,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Icon(
                  LucideIcons.chevronRight,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  bloc.add(const ExportData(isJson: false));
                  Navigator.pop(context);
                },
              ),
              Divider(
                indent: 72,
                endIndent: 16,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer,
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                  child: Icon(
                    LucideIcons.lock,
                    color: theme.colorScheme.onTertiaryContainer,
                    size: 20,
                  ),
                ),
                title: Text(l10n.exportEncrypted),
                subtitle: Text(
                  l10n.encryptedPasswordProtected,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Icon(
                  LucideIcons.chevronRight,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showPasswordDialog(context, bloc, isExport: true);
                },
              ),
              const SizedBox(height: AppDimensions.spaceS),
            ],
          ),
        ),
      ),
    );
  }

  void _showImportPicker(BuildContext context, SettingsBloc bloc) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = context.colors;
    final textTheme = context.typography;
    final outerContext = context; // Capture for use after pop

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppDimensions.spaceM),
                  decoration: BoxDecoration(
                    color: colors.surfaceDim,
                    borderRadius: AppDimensions.borderRadiusS,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.importData,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceM),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                  child: Icon(
                    LucideIcons.braces,
                    color: colors.primary,
                    size: 20,
                  ),
                ),
                title: Text(l10n.importJson),
                subtitle: Text(
                  l10n.importFromJsonBackup,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Icon(
                  LucideIcons.chevronRight,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  bloc.add(const ImportData(isJson: true));
                  Navigator.pop(context);
                },
              ),
              Divider(
                indent: 72,
                endIndent: 16,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                  child: Icon(
                    LucideIcons.table,
                    color: theme.colorScheme.onSecondaryContainer,
                    size: 20,
                  ),
                ),
                title: Text(l10n.importCsv),
                subtitle: Text(
                  l10n.importFromSpreadsheet,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Icon(
                  LucideIcons.chevronRight,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  bloc.add(const ImportData(isJson: false));
                  Navigator.pop(context);
                },
              ),
              Divider(
                indent: 72,
                endIndent: 16,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer,
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                  child: Icon(
                    LucideIcons.lock,
                    color: theme.colorScheme.onTertiaryContainer,
                    size: 20,
                  ),
                ),
                title: Text(l10n.importEncrypted),
                subtitle: Text(
                  l10n.importFromEncryptedBackup,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Icon(
                  LucideIcons.chevronRight,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  Navigator.pop(outerContext);
                  _handleEncryptedImport(outerContext, bloc);
                },
              ),
              const SizedBox(height: AppDimensions.spaceS),
            ],
          ),
        ),
      ),
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppDimensions.spaceS),
            SizedBox(
              width: 40,
              height: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.surfaceDim,
                  borderRadius: AppDimensions.borderRadiusS,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            ListTile(
              leading: const Icon(LucideIcons.monitor),
              title: Text(l10n.system),
              onTap: () {
                cubit.setTheme(ThemeType.system);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.sun),
              title: Text(l10n.light),
              onTap: () {
                cubit.setTheme(ThemeType.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.moon),
              title: Text(l10n.dark),
              onTap: () {
                cubit.setTheme(ThemeType.dark);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.sparkles),
              title: Text(l10n.amoled),
              onTap: () {
                cubit.setTheme(ThemeType.amoled);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: AppDimensions.spaceM),
          ],
        ),
      ),
    );
  }

  void _showPasswordDialog(
    BuildContext context,
    SettingsBloc bloc, {
    required bool isExport,
    String? filePath,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          isExport ? l10n.exportEncrypted : l10n.importEncrypted,
          style: TextStyle(color: colors.onSurface),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: passwordController,
            obscureText: true,
            autofocus: true,
            style: TextStyle(color: colors.onSurface),
            decoration: InputDecoration(
              labelText: l10n.passwordLabel,
              labelStyle: TextStyle(color: colors.onSurfaceVariant),
              hintText: isExport
                  ? l10n.enterExportPassword
                  : l10n.enterImportPassword,
              hintStyle: TextStyle(color: colors.onSurfaceVariant),
              prefixIcon: Icon(LucideIcons.lock, color: colors.primary),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.outline),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.error),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colors.error, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.passwordRequired;
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext);
                if (isExport) {
                  bloc.add(
                    ExportEncryptedData(password: passwordController.text),
                  );
                } else {
                  bloc.add(
                    ImportEncryptedData(
                      password: passwordController.text,
                      filePath: filePath,
                    ),
                  );
                }
              }
            },
            child: Text(isExport ? l10n.export : l10n.import),
          ),
        ],
      ),
    );
  }

  /// Handles encrypted import: pick file first, then show password dialog
  Future<void> _handleEncryptedImport(
    BuildContext context,
    SettingsBloc bloc,
  ) async {
    // Pick file first using FileType.any to support custom extensions on iOS
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      // Only accept .pvault files
      if (filePath.endsWith('.pvault')) {
        if (context.mounted) {
          _showPasswordDialog(
            context,
            bloc,
            isExport: false,
            filePath: filePath,
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.importFailed)),
          );
        }
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 12),
      child: Text(
        title.toUpperCase(),
        style: context.typography.labelLarge?.copyWith(
          color: context.colors.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
