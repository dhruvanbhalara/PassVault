import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/settings/presentation/widgets/import_export_dialogs.dart';
import 'package:passvault/features/settings/presentation/widgets/settings_shared_widgets.dart';
import 'package:passvault/l10n/app_localizations.dart';

/// Section for data management settings.
class DataManagementSection extends StatelessWidget {
  const DataManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(title: l10n.dataManagement),
        Card(
          child: Column(
            children: [
              ListTile(
                key: const Key('settings_export_tile'),
                leading: const Icon(LucideIcons.upload),
                title: Text(l10n.exportData),
                trailing: const Icon(LucideIcons.chevronRight),
                onTap: () => _showExportPicker(context),
              ),
              const Divider(
                indent: AppDimensions.listTileDividerIndent,
                endIndent: AppSpacing.m,
                height: 1,
              ),
              ListTile(
                key: const Key('settings_import_tile'),
                leading: const Icon(LucideIcons.download),
                title: Text(l10n.importData),
                trailing: const Icon(LucideIcons.chevronRight),
                onTap: () => _showImportPicker(context),
              ),
              if (kDebugMode) ...[
                const Divider(
                  indent: AppDimensions.listTileDividerIndent,
                  endIndent: AppSpacing.m,
                  height: 1,
                ),
                ListTile(
                  key: const Key('settings_clear_db_tile'),
                  leading: Icon(LucideIcons.trash2, color: theme.error),
                  title: Text(
                    l10n.clearDatabase,
                    style: TextStyle(color: theme.error),
                  ),
                  subtitle: Text(l10n.debugDeleteAllPasswords),
                  trailing: const Icon(LucideIcons.chevronRight),
                  onTap: () => _showClearDatabaseDialog(context),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _showExportPicker(BuildContext context) {
    final bloc = context.read<ImportExportBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: context.theme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => ExportPickerSheet(bloc: bloc),
    );
  }

  void _showImportPicker(BuildContext context) {
    final bloc = context.read<ImportExportBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: context.theme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) => ImportPickerSheet(bloc: bloc),
    );
  }

  void _showClearDatabaseDialog(BuildContext context) {
    final bloc = context.read<ImportExportBloc>();
    final l10n = AppLocalizations.of(context)!;
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
