import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_bloc.dart';

/// Sheet for picking data import format.
class ImportPickerSheet extends StatelessWidget {
  final ImportExportBloc bloc;

  const ImportPickerSheet({super.key, required this.bloc});

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
              title: l10n.importData,
              variant: AppSectionHeaderVariant.simple,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          // Options
          AppListOption(
            key: const Key('import_file_tile'),
            icon: LucideIcons.fileInput,
            iconColor: theme.primary,
            title: l10n.importData,
            subtitle: _importFormatsLabel(l10n),
            onTap: () {
              Navigator.pop(context);
              bloc.add(const PrepareImportFromFileEvent());
            },
          ),
          const SizedBox(height: AppSpacing.m),
        ],
      ),
    );
  }

  String _importFormatsLabel(AppLocalizations l10n) {
    final formats = [l10n.importJson, l10n.importCsv, l10n.importEncrypted];
    return formats.join(', ');
  }
}
