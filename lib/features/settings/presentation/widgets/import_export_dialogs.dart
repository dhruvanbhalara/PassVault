import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/l10n/app_localizations.dart';

/// Sheet for picking data export format.
class ExportPickerSheet extends StatelessWidget {
  final ImportExportBloc bloc;

  const ExportPickerSheet({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = context.theme;
    final textTheme = context.typography;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: AppSpacing.s,
          bottom: context.responsive(AppSpacing.s, tablet: AppSpacing.m),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DragHandle(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.m,
                ),
                child: Text(
                  l10n.exportData,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              _PickerOption(
                key: const Key('export_json_tile'),
                icon: LucideIcons.braces,
                color: theme.primary,
                title: l10n.exportJson,
                subtitle: l10n.jsonBackupFormat,
                onTap: () {
                  Navigator.pop(context);
                  bloc.add(const ExportDataEvent(isJson: true));
                },
              ),
              _PickerDivider(),
              _PickerOption(
                key: const Key('export_csv_tile'),
                icon: LucideIcons.table,
                color: theme.secondary,
                title: l10n.exportCsv,
                subtitle: l10n.csvSpreadsheetFormat,
                onTap: () {
                  Navigator.pop(context);
                  bloc.add(const ExportDataEvent(isJson: false));
                },
              ),
              _PickerDivider(),
              _PickerOption(
                key: const Key('export_encrypted_tile'),
                icon: LucideIcons.lock,
                color: theme.warning,
                title: l10n.exportEncrypted,
                subtitle: l10n.encryptedPasswordProtected,
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) =>
                        PasswordProtectedDialog(bloc: bloc, isExport: true),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sheet for picking data import format.
class ImportPickerSheet extends StatelessWidget {
  final ImportExportBloc bloc;

  const ImportPickerSheet({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = context.theme;
    final textTheme = context.typography;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          top: AppSpacing.s,
          bottom: context.responsive(AppSpacing.s, tablet: AppSpacing.m),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DragHandle(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.m,
                ),
                child: Text(
                  l10n.importData,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              _PickerOption(
                key: const Key('import_json_tile'),
                icon: LucideIcons.braces,
                color: theme.primary,
                title: l10n.importJson,
                subtitle: l10n.importFromJsonBackup,
                onTap: () {
                  Navigator.pop(context);
                  bloc.add(const ImportDataEvent(isJson: true));
                },
              ),
              _PickerDivider(),
              _PickerOption(
                key: const Key('import_csv_tile'),
                icon: LucideIcons.table,
                color: theme.secondary,
                title: l10n.importCsv,
                subtitle: l10n.importFromSpreadsheet,
                onTap: () {
                  Navigator.pop(context);
                  bloc.add(const ImportDataEvent(isJson: false));
                },
              ),
              _PickerDivider(),
              _PickerOption(
                key: const Key('import_encrypted_tile'),
                icon: LucideIcons.lock,
                color: theme.warning,
                title: l10n.importEncrypted,
                subtitle: l10n.importFromEncryptedBackup,
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) =>
                        PasswordProtectedDialog(bloc: bloc, isExport: false),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.s),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dialog for password-protected data operations.
class PasswordProtectedDialog extends StatefulWidget {
  final ImportExportBloc bloc;
  final bool isExport;

  const PasswordProtectedDialog({
    super.key,
    required this.bloc,
    required this.isExport,
  });

  @override
  State<PasswordProtectedDialog> createState() =>
      _PasswordProtectedDialogState();
}

class _PasswordProtectedDialogState extends State<PasswordProtectedDialog> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = context.theme;

    return AlertDialog(
      backgroundColor: theme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      title: Text(
        widget.isExport ? l10n.exportEncrypted : l10n.importEncrypted,
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _passwordController,
          obscureText: true,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.passwordLabel,
            hintText: widget.isExport
                ? l10n.enterExportPassword
                : l10n.enterImportPassword,
            prefixIcon: Icon(LucideIcons.lock, color: theme.primary),
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
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final password = _passwordController.text;
              Navigator.pop(context);

              if (widget.isExport) {
                widget.bloc.add(ExportEncryptedEvent(password));
              } else {
                widget.bloc.add(ImportEncryptedEvent(password: password));
              }
            }
          },
          child: Text(widget.isExport ? l10n.export : l10n.import),
        ),
      ],
    );
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: AppSpacing.m),
        decoration: BoxDecoration(
          color: context.theme.surfaceDim,
          borderRadius: BorderRadius.circular(AppRadius.s),
        ),
      ),
    );
  }
}

class _PickerOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PickerOption({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s),
          child: Icon(icon, color: color, size: AppIconSize.m),
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle, style: context.typography.bodySmall),
      trailing: const Icon(LucideIcons.chevronRight),
      onTap: onTap,
    );
  }
}

class _PickerDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: AppDimensions.listTileDividerIndent,
      endIndent: AppSpacing.m,
      color: context.theme.outline.withValues(alpha: 0.1),
    );
  }
}
