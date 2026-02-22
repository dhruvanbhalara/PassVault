import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/presentation/bloc/add_edit_password/add_edit_password_bloc.dart';
import 'package:uuid/uuid.dart';

import 'widgets/password_field_section.dart';
import 'widgets/password_form_fields.dart';

/// Screen for adding or editing a password entry.
class AddEditPasswordScreen extends StatelessWidget {
  final String? id;

  const AddEditPasswordScreen({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddEditPasswordBloc>(),
      child: AddEditPasswordView(id: id),
    );
  }
}

@visibleForTesting
class AddEditPasswordView extends StatefulWidget {
  final String? id;

  const AddEditPasswordView({super.key, this.id});

  @override
  State<AddEditPasswordView> createState() => _AddEditPasswordViewState();
}

class _AddEditPasswordViewState extends State<AddEditPasswordView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _appNameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late ScrollController _scrollController;
  bool _obscurePassword = true;
  String? _lastAppliedGeneratedPassword;
  String? _selectedStrategyId;

  @override
  void initState() {
    super.initState();
    _appNameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordController.addListener(_onPasswordChanged);
    _scrollController = ScrollController();

    if (widget.id != null) {
      context.read<AddEditPasswordBloc>().add(LoadEntry(widget.id!));
    } else {
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
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final entry = PasswordEntry(
        id: widget.id ?? const Uuid().v7(),
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
        switch (state) {
          case AddEditGenerated():
            if (state.generatedPassword != _lastAppliedGeneratedPassword) {
              _lastAppliedGeneratedPassword = state.generatedPassword;
              _passwordController.text = state.generatedPassword;
              setState(() => _obscurePassword = false);
            }
          case AddEditLoaded(:final entry):
            _appNameController.text = entry.appName;
            _usernameController.text = entry.username;
            // Only update password if controller is empty to avoid overwriting user edits
            // or if we just loaded the entry
            if (_passwordController.text.isEmpty) {
              _passwordController.text = entry.password;
            }
          case AddEditSuccess():
            Navigator.of(context).pop();
          case AddEditFailure(:final errorMessage):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: theme.error,
                behavior: SnackBarBehavior.floating,
                duration: AppDuration.normal,
              ),
            );
          case AddEditInitial():
          case AddEditSaving():
          case AddEditLoading():
            break;
        }

        // Initialize selected strategy if needed
        if (state.settings != null && _selectedStrategyId == null) {
          setState(() {
            _selectedStrategyId = state.settings!.defaultStrategyId;
          });
        }
      },
      builder: (context, state) {
        final isAmoled = context.isAmoled;

        return Scaffold(
          bottomNavigationBar: PersistentBottomBar(
            scrollController: _scrollController,
            child: FloatingActionButton.extended(
              key: const Key('add_edit_save_button'),
              heroTag: 'add_edit_save_button',
              onPressed: state is AddEditSaving
                  ? null
                  : () => _handleSave(context),
              backgroundColor: theme.primary,
              foregroundColor: theme.onPrimary,
              icon: state is AddEditSaving
                  ? const SizedBox(
                      width: AppIconSize.m,
                      height: AppIconSize.m,
                      child: AppLoader(key: Key('add_edit_saving_loader')),
                    )
                  : const Icon(LucideIcons.save),
              label: Text(
                widget.id == null ? l10n.savePassword : l10n.updatePassword,
              ),
            ),
          ),
          body: RepaintBoundary(
            child: CustomScrollView(
              controller: _scrollController,
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
                        title: widget.id == null
                            ? l10n.addPassword
                            : l10n.editPassword,
                        showBack: true,
                        onBack: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.l,
                    AppSpacing.l,
                    AppSpacing.l,

                    AppSpacing.l,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppCard(
                            hasGlow: isAmoled,
                            padding: const EdgeInsets.all(AppSpacing.l),
                            child: Column(
                              spacing: AppSpacing.l,
                              children: [
                                PasswordFormFields(
                                  l10n: l10n,
                                  appNameController: _appNameController,
                                  usernameController: _usernameController,
                                ),
                                PasswordFieldSection(
                                  l10n: l10n,
                                  passwordController: _passwordController,
                                  obscurePassword: _obscurePassword,
                                  onToggleVisibility: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  state: state,
                                  selectedStrategyId: _selectedStrategyId,
                                  onStrategyChanged: (value) {
                                    if (value != null) {
                                      setState(
                                        () => _selectedStrategyId = value,
                                      );
                                      context.read<AddEditPasswordBloc>().add(
                                        GenerateStrongPassword(
                                          strategyId: value,
                                        ),
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
                              ],
                            ),
                          ),

                          const SizedBox(height: AppSpacing.xxl),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
