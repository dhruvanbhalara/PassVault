import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/settings/presentation/widgets/password_protected_dialog.dart';

/// Sheet for picking data export format.
class ExportPickerSheet extends StatelessWidget {
  final ImportExportBloc bloc;

  const ExportPickerSheet({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSpacing.s),
          // Drag handle
          SizedBox(
            width: AppSpacing.dragHandleWidth,
            height: AppSpacing.dragHandleHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.surfaceDim,
                borderRadius: BorderRadius.circular(AppRadius.s),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: AppSectionHeader(
              title: l10n.exportData,
              variant: AppSectionHeaderVariant.simple,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          // Options
          AppListOption(
            key: const Key('export_json_tile'),
            icon: LucideIcons.braces,
            iconColor: theme.primary,
            title: l10n.exportJson,
            subtitle: l10n.jsonBackupFormat,
            onTap: () {
              Navigator.pop(context);
              bloc.add(const ExportDataEvent(isJson: true));
            },
          ),
          const Divider(indent: AppDimensions.listTileDividerIndent, height: 1),
          AppListOption(
            key: const Key('export_csv_tile'),
            icon: LucideIcons.table,
            iconColor: theme.secondary,
            title: l10n.exportCsv,
            subtitle: l10n.csvSpreadsheetFormat,
            onTap: () {
              Navigator.pop(context);
              bloc.add(const ExportDataEvent(isJson: false));
            },
          ),
          const Divider(indent: AppDimensions.listTileDividerIndent, height: 1),
          AppListOption(
            key: const Key('export_encrypted_tile'),
            icon: LucideIcons.lock,
            iconColor: theme.warning,
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
          const SizedBox(height: AppSpacing.m),
        ],
      ),
    );
  }
}
