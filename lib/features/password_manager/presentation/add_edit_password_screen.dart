import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/presentation/bloc/add_edit_password_bloc.dart';
import 'package:uuid/uuid.dart';

import 'widgets/password_field_section.dart';
import 'widgets/password_form_fields.dart';

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
                    PasswordFormFields(
                      l10n: l10n,
                      appNameController: _appNameController,
                      usernameController: _usernameController,
                    ),
                    const SizedBox(height: AppSpacing.l),
                    PasswordFieldSection(
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
