import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/presentation/bloc/add_edit_password_bloc.dart';
import 'package:passvault/features/settings/domain/entities/password_generation_settings.dart';
import 'package:passvault/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

/// Screen for adding or editing a password entry.
class AddEditPasswordScreen extends StatelessWidget {
  final PasswordEntry? entry;

  const AddEditPasswordScreen({super.key, this.entry});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddEditPasswordBloc>(),
      child: AddEditPasswordView(entry: entry),
    );
  }
}

@visibleForTesting
class AddEditPasswordView extends StatefulWidget {
  final PasswordEntry? entry;

  const AddEditPasswordView({super.key, this.entry});

  @override
  State<AddEditPasswordView> createState() => _AddEditPasswordViewState();
}

class _AddEditPasswordViewState extends State<AddEditPasswordView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _appNameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;
  String? _lastAppliedGeneratedPassword;
  String? _selectedStrategyId;

  @override
  void initState() {
    super.initState();
    _appNameController = TextEditingController(
      text: widget.entry?.appName ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.entry?.username ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.entry?.password ?? '',
    );
    _passwordController.addListener(_onPasswordChanged);

    if (_passwordController.text.isNotEmpty) {
      context.read<AddEditPasswordBloc>().add(
        PasswordChanged(_passwordController.text),
      );
    } else if (widget.entry == null) {
      // Auto-generate strong password for new entries
      context.read<AddEditPasswordBloc>().add(const GenerateStrongPassword());
    }
  }

  void _onPasswordChanged() => context.read<AddEditPasswordBloc>().add(
    PasswordChanged(_passwordController.text),
  );

  @override
  void dispose() {
    _appNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final entry = PasswordEntry(
        id: widget.entry?.id ?? const Uuid().v4(),
        appName: _appNameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        lastUpdated: DateTime.now(),
      );

      context.read<AddEditPasswordBloc>().add(SaveEntry(entry));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return BlocConsumer<AddEditPasswordBloc, AddEditPasswordState>(
      listener: (context, state) {
        if (state.status == AddEditStatus.generated &&
            state.generatedPassword != _lastAppliedGeneratedPassword) {
          _lastAppliedGeneratedPassword = state.generatedPassword;
          _passwordController.text = state.generatedPassword;
          setState(() => _obscurePassword = false);
        } else if (state.status == AddEditStatus.success) {
          Navigator.of(context).pop();
        } else if (state.status == AddEditStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? l10n.errorOccurred),
              backgroundColor: theme.error,
              behavior: SnackBarBehavior.floating,
              duration: AppDuration.normal,
            ),
          );
        }

        // Initialize selected strategy if needed
        if (state.settings != null && _selectedStrategyId == null) {
          setState(() {
            _selectedStrategyId = state.settings!.defaultStrategyId;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.entry == null ? l10n.addPassword : l10n.editPassword,
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            key: const Key('add_edit_save_button'),
            onPressed: state.status == AddEditStatus.saving
                ? null
                : () => _handleSave(context),
            icon: state.status == AddEditStatus.saving
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(theme.onPrimary),
                    ),
                  )
                : const Icon(LucideIcons.save),
            label: Text(l10n.save),
          ),
          body: RepaintBoundary(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FormFields(
                      l10n: l10n,
                      appNameController: _appNameController,
                      usernameController: _usernameController,
                    ),
                    const SizedBox(height: AppSpacing.l),
                    _PasswordFieldSection(
                      l10n: l10n,
                      passwordController: _passwordController,
                      obscurePassword: _obscurePassword,
                      onToggleVisibility: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      state: state,
                      selectedStrategyId: _selectedStrategyId,
                      onStrategyChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedStrategyId = value;
                          });
                          context.read<AddEditPasswordBloc>().add(
                            GenerateStrongPassword(strategyId: value),
                          );
                        }
                      },
                      onGenerate: () {
                        context.read<AddEditPasswordBloc>().add(
                          GenerateStrongPassword(
                            strategyId: _selectedStrategyId,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.x4xl), // Fab spacing
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FormFields extends StatelessWidget {
  final AppLocalizations l10n;
  final TextEditingController appNameController;
  final TextEditingController usernameController;

  const _FormFields({
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

class _PasswordFieldSection extends StatelessWidget {
  final AppLocalizations l10n;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleVisibility;
  final AddEditPasswordState state;
  final String? selectedStrategyId;
  final ValueChanged<String?> onStrategyChanged;
  final VoidCallback onGenerate;

  const _PasswordFieldSection({
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
