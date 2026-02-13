import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';
import 'package:passvault/features/password_manager/presentation/bloc/add_edit_password_bloc.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';

class PasswordFieldSection extends StatelessWidget {
  final AppLocalizations l10n;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleVisibility;
  final AddEditPasswordState state;
  final String? selectedStrategyId;
  final ValueChanged<String?> onStrategyChanged;
  final VoidCallback onGenerate;

  const PasswordFieldSection({
    super.key,
    required this.l10n,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleVisibility,
    required this.state,
    this.selectedStrategyId,
    required this.onStrategyChanged,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          key: const Key('add_edit_password_field'),
          label: l10n.passwordLabel,
          controller: passwordController,
          obscureText: obscurePassword,
          prefixIcon: LucideIcons.lock,
          hint: l10n.hintPassword,
          suffixIcon: IconButton(
            key: const Key('add_edit_visibility_toggle'),
            icon: Icon(obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff),
            onPressed: onToggleVisibility,
          ),
          validator: (v) => v?.isEmpty == true ? l10n.errorOccurred : null,
        ),
        const SizedBox(height: AppSpacing.m),
        if (passwordController.text.isNotEmpty)
          PasswordStrengthIndicator(strength: state.strength),
        const SizedBox(height: AppSpacing.l),
        if (state.settings != null && state.settings!.strategies.isNotEmpty)
          _StrategyDropdown(
            l10n: l10n,
            strategies: state.settings!.strategies,
            selectedId: selectedStrategyId,
            onChanged: onStrategyChanged,
          ),
        _GenerateButton(l10n: l10n, onGenerate: onGenerate),
      ],
    );
  }
}

class _StrategyDropdown extends StatelessWidget {
  final AppLocalizations l10n;
  final List<PasswordGenerationStrategy> strategies;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const _StrategyDropdown({
    required this.l10n,
    required this.strategies,
    this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: DropdownButtonFormField<String>(
        initialValue: selectedId,
        decoration: InputDecoration(
          labelText: l10n.generationStrategy,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.s,
          ),
        ),
        items: strategies.map((strategy) {
          return DropdownMenuItem(
            value: strategy.id,
            child: Text(strategy.name),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _GenerateButton extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onGenerate;

  const _GenerateButton({required this.l10n, required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        key: const Key('add_edit_generate_button'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
          side: BorderSide(color: theme.primary.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.m),
          ),
        ),
        onPressed: onGenerate,
        icon: const Icon(LucideIcons.sparkles, size: AppIconSize.s),
        label: Text(l10n.generate),
      ),
    );
  }
}
