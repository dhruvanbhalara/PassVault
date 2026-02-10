import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/l10n/app_localizations.dart';

class PasswordFormFields extends StatelessWidget {
  final AppLocalizations l10n;
  final TextEditingController appNameController;
  final TextEditingController usernameController;

  const PasswordFormFields({
    super.key,
    required this.l10n,
    required this.appNameController,
    required this.usernameController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          key: const Key('add_edit_app_name_field'),
          label: l10n.appNameLabel,
          hint: l10n.hintAppName,
          controller: appNameController,
          textInputAction: TextInputAction.next,
          prefixIcon: LucideIcons.globe,
          validator: (v) => v?.isEmpty == true ? l10n.errorOccurred : null,
        ),
        const SizedBox(height: AppSpacing.l),
        AppTextField(
          key: const Key('add_edit_username_field'),
          label: l10n.usernameLabel,
          hint: l10n.hintUsername,
          controller: usernameController,
          textInputAction: TextInputAction.next,
          prefixIcon: LucideIcons.atSign,
        ),
      ],
    );
  }
}
