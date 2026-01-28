import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/settings/presentation/widgets/password_protected_dialog.dart';
import 'package:passvault/features/settings/presentation/widgets/picker_container.dart';
import 'package:passvault/features/settings/presentation/widgets/picker_divider.dart';
import 'package:passvault/features/settings/presentation/widgets/picker_option.dart';

/// Sheet for picking data export format.
class ExportPickerSheet extends StatelessWidget {
  final ImportExportBloc bloc;

  const ExportPickerSheet({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return PickerContainer(
      title: l10n.exportData,
      options: [
        PickerOption(
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
        const PickerDivider(),
        PickerOption(
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
        const PickerDivider(),
        PickerOption(
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
      ],
    );
  }
}
