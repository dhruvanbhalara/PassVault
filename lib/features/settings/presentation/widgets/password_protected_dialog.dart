import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_bloc.dart';

class PasswordProtectedDialog extends StatefulWidget {
  final ImportExportBloc bloc;
  final bool isExport;
  final String? filePath;

  const PasswordProtectedDialog({
    super.key,
    required this.bloc,
    required this.isExport,
    this.filePath,
  });

  @override
  State<PasswordProtectedDialog> createState() =>
      _PasswordProtectedDialogState();
}

class _PasswordProtectedDialogState extends State<PasswordProtectedDialog> {
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

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
    final l10n = context.l10n;
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
          validator: (value) =>
              (value == null || value.isEmpty) ? l10n.passwordRequired : null,
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
                widget.bloc.add(
                  ImportEncryptedEvent(password, filePath: widget.filePath),
                );
              }
            }
          },
          child: Text(widget.isExport ? l10n.export : l10n.import),
        ),
      ],
    );
  }
}
