import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/presentation/widgets/password_strength_indicator.dart';

class PasswordFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController appNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleVisibility;
  final double strength;
  final VoidCallback onGenerate;

  const PasswordFormFields({
    super.key,
    required this.formKey,
    required this.appNameController,
    required this.usernameController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleVisibility,
    required this.strength,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          const SizedBox(height: AppSpacing.l),
          _PasswordInputSection(
            controller: passwordController,
            obscureText: obscurePassword,
            onToggleVisibility: onToggleVisibility,
            strength: strength,
            onGenerate: onGenerate,
          ),
          const SizedBox(height: AppSpacing.x4xl),
        ],
      ),
    );
  }
}

class _PasswordInputSection extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final double strength;
  final VoidCallback onGenerate;

  const _PasswordInputSection({
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
    required this.strength,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Column(
      children: [
        AppTextField(
          key: const Key('add_edit_password_field'),
          label: l10n.passwordLabel,
          controller: controller,
          obscureText: obscureText,
          prefixIcon: LucideIcons.lock,
          hint: l10n.hintPassword,
          suffixIcon: IconButton(
            key: const Key('add_edit_visibility_toggle'),
            icon: Icon(
              obscureText ? LucideIcons.eye : LucideIcons.eyeOff,
              color: theme.onSurface.withValues(alpha: 0.7),
            ),
            onPressed: onToggleVisibility,
          ),
          validator: (v) => v?.isEmpty == true ? l10n.errorOccurred : null,
        ),
        const SizedBox(height: AppSpacing.m),
        if (controller.text.isNotEmpty)
          PasswordStrengthIndicator(strength: strength),
        const SizedBox(height: AppSpacing.l),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            key: const Key('add_edit_generate_button'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
              side: BorderSide(color: theme.primary.withValues(alpha: 0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.m),
              ),
              foregroundColor: theme.primary,
            ),
            onPressed: onGenerate,
            icon: const Icon(LucideIcons.sparkles, size: AppIconSize.s),
            label: Text(l10n.generate),
          ),
        ),
      ],
    );
  }
}
