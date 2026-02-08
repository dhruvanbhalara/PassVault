import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';
import 'package:passvault/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:passvault/features/settings/presentation/widgets/appearance_section.dart';
import 'package:passvault/features/settings/presentation/widgets/data_management_section.dart';
import 'package:passvault/features/settings/presentation/widgets/security_section.dart';

/// Screen for managing application settings, security, and data.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SettingsBloc>()..add(const LoadSettings()),
        ),
        BlocProvider(create: (context) => getIt<ImportExportBloc>()),
      ],
      child: const SettingsView(),
    );
  }
}

/// The stateful UI for the settings screen.
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<SettingsBloc, SettingsState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) => _handleSettingsState(context, state),
        ),
        BlocListener<ImportExportBloc, ImportExportState>(
          listener: (context, state) =>
              _handleImportExportState(context, state),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.settings)),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          children: const [
            AppearanceSection(),
            SizedBox(height: AppSpacing.l),
            SecuritySection(),
            SizedBox(height: AppSpacing.l),
            DataManagementSection(),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _handleSettingsState(BuildContext context, SettingsState state) {
    // Only show snackbar for errors
    if (state.status == SettingsStatus.failure) {
      final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
      if (isCurrent) {
        _showSnackBar(context, context.l10n.errorOccurred, isError: true);
      }
    }
  }

  void _handleImportExportState(BuildContext context, ImportExportState state) {
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    if (!isCurrent) return; // Don't handle if not current route

    // Handle each state type
    if (state is ImportSuccess) {
      _showSnackBar(context, context.l10n.importSuccess);
      context.read<ImportExportBloc>().add(const ResetMigrationStatus());
    } else if (state is ExportSuccess) {
      _showSnackBar(context, context.l10n.exportSuccess);
      context.read<ImportExportBloc>().add(const ResetMigrationStatus());
    } else if (state is ClearDatabaseSuccess) {
      _showSnackBar(context, context.l10n.databaseCleared);
      context.read<ImportExportBloc>().add(const ResetMigrationStatus());
    } else if (state is ImportExportFailure) {
      if (state.error != DataMigrationError.cancelled) {
        _showSnackBar(
          context,
          _getMigrationErrorMessage(state.error, context),
          isError: true,
        );
      }
      context.read<ImportExportBloc>().add(const ResetMigrationStatus());
    } else if (state is DuplicatesDetected) {
      context.push(AppRoutes.resolveDuplicates, extra: state.duplicates);
      context.read<ImportExportBloc>().add(const ResetMigrationStatus());
    } else if (state is DuplicatesResolved) {
      _showSnackBar(context, context.l10n.importSuccess);
      context.read<ImportExportBloc>().add(const ResetMigrationStatus());
    }
  }

  String _getMigrationErrorMessage(
    DataMigrationError error,
    BuildContext context,
  ) {
    final l10n = context.l10n;
    switch (error) {
      case DataMigrationError.noDataToExport:
        return l10n.noDataToExport;
      case DataMigrationError.importFailed:
        return l10n.importFailed;
      case DataMigrationError.wrongPassword:
        return l10n.wrongPassword;
      case DataMigrationError.fileNotFound:
        return l10n.fileNotFound;
      case DataMigrationError.invalidFormat:
        return l10n.importFailed;
      default:
        return l10n.errorOccurred;
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final theme = context.theme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? theme.error : null,
      ),
    );
  }
}
