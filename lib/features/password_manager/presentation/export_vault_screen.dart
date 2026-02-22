import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_bloc.dart';

class ExportVaultScreen extends StatefulWidget {
  const ExportVaultScreen({super.key});

  @override
  State<ExportVaultScreen> createState() => _ExportVaultScreenState();
}

class _ExportVaultScreenState extends State<ExportVaultScreen> {
  bool _isJsonSelected = true;
  bool _encryptExport = true;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isAmoled = context.isAmoled;
    final l10n = context.l10n;

    return BlocListener<ImportExportBloc, ImportExportState>(
      listener: (context, state) {
        if (state is ExportSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.exportSuccess)));
          context.read<ImportExportBloc>().add(const ResetMigrationStatus());
          Navigator.of(context).pop();
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
                  child: PageHeader(
                    title: l10n.exportVault,
                    showBack: true,
                    onBack: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.l),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Warning Banner
                    AppCard(
                      hasGlow: isAmoled,
                      backgroundColor: theme.error.withValues(alpha: 0.1),
                      padding: const EdgeInsets.all(AppSpacing.m),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.triangleAlert,
                            color: theme.error,
                            size: 24,
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: Text(
                              l10n.warningSensitiveData,
                              style: context.typography.bodySmall?.copyWith(
                                color: theme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Format Selection
                    _SectionHeader(title: l10n.exportFormat),
                    AppRadioOptionCard(
                      key: const Key('export_format_json_option'),
                      icon: LucideIcons.fileCode,
                      title: l10n.jsonRecommended,
                      description: l10n.jsonDesc,
                      isSelected: _isJsonSelected,
                      onTap: () => setState(() => _isJsonSelected = true),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    AppRadioOptionCard(
                      key: const Key('export_format_csv_option'),
                      icon: LucideIcons.fileSpreadsheet,
                      title: l10n.csvSpreadsheet,
                      description: l10n.csvDesc,
                      isSelected: !_isJsonSelected,
                      onTap: () => setState(() => _isJsonSelected = false),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Encryption Toggle
                    AppCard(
                      hasGlow: isAmoled,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m,
                        vertical: AppSpacing.s,
                      ),
                      child: SwitchListTile(
                        key: const Key('export_encrypt_switch'),
                        title: Text(l10n.encryptWithPassword),
                        subtitle: Text(l10n.encryptDesc),
                        value: _encryptExport,
                        onChanged: (v) => setState(() => _encryptExport = v),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    if (_encryptExport) ...[
                      const SizedBox(height: AppSpacing.l),
                      AppTextField(
                        key: const Key('export_password_field'),
                        label: l10n.encryptionPassword,
                        hint: l10n.encryptionPassword,
                        controller: _passwordController,
                        obscureText: true,
                        prefixIcon: LucideIcons.lock,
                        hasFocusGlow: isAmoled,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                    AppButton(
                      key: const Key('export_button'),
                      text: l10n.exportNow,
                      onPressed: () => _handleExport(context),
                      hasGlow: isAmoled,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleExport(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<ImportExportBloc>();

    if (_encryptExport) {
      final password = _passwordController.text.trim();
      if (password.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.passwordRequired)));
        return;
      }
      bloc.add(ExportEncryptedEvent(password));
      return;
    }

    bloc.add(ExportDataEvent(isJson: _isJsonSelected));
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.s, bottom: AppSpacing.s),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: context.typography.labelMedium?.copyWith(
            color: context.theme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
