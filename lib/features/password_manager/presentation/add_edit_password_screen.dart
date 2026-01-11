import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/home/presentation/bloc/password_bloc.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/presentation/bloc/add_edit_password_bloc.dart';
import 'package:passvault/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

/// Screen for adding or editing a password entry.
///
/// Provides a form for app name, username, and password,
/// with integrated password generation and strength estimation.
class AddEditPasswordScreen extends StatelessWidget {
  /// Optional entry to edit. If null, a new entry will be created.
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

/// Internal view widget for [AddEditPasswordScreen].
///
/// Separated to decouple [BlocProvider] setup from UI code.
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

  /// Track the last applied generated password to prevent repeated application
  /// in the listener which could overwrite manual edits.
  String? _lastAppliedGeneratedPassword;

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

    // Initial strength check for existing passwords
    if (_passwordController.text.isNotEmpty) {
      context.read<AddEditPasswordBloc>().add(
        PasswordChanged(_passwordController.text),
      );
    }
  }

  void _onPasswordChanged() {
    context.read<AddEditPasswordBloc>().add(
      PasswordChanged(_passwordController.text),
    );
  }

  @override
  void dispose() {
    _appNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validates and saves the current form data.
  void _handleSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final entry = PasswordEntry(
        id: widget.entry?.id ?? const Uuid().v4(),
        appName: _appNameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        lastUpdated: DateTime.now(),
      );

      // Trigger the global PasswordBloc to persist changes.
      getIt<PasswordBloc>().add(
        widget.entry == null ? AddPassword(entry) : UpdatePassword(entry),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocConsumer<AddEditPasswordBloc, AddEditPasswordState>(
      listener: (context, state) {
        // Auto-apply generated password to the controller.
        if (state.status == AddEditStatus.generated &&
            state.generatedPassword != _lastAppliedGeneratedPassword) {
          _lastAppliedGeneratedPassword = state.generatedPassword;
          _passwordController.text = state.generatedPassword;
          setState(() {
            _obscurePassword = false;
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
            onPressed: () => _handleSave(context),
            icon: const Icon(LucideIcons.save),
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
                    AppTextField(
                      key: const Key('add_edit_app_name_field'),
                      label: l10n.appNameLabel,
                      hint: l10n.hintAppName,
                      controller: _appNameController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: LucideIcons.globe,
                      validator: (v) =>
                          v?.isEmpty == true ? l10n.errorOccurred : null,
                    ),
                    const SizedBox(height: AppSpacing.l),
                    AppTextField(
                      key: const Key('add_edit_username_field'),
                      label: l10n.usernameLabel,
                      hint: l10n.hintUsername,
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      prefixIcon: LucideIcons.atSign,
                    ),
                    const SizedBox(height: AppSpacing.l),
                    Column(
                      children: [
                        AppTextField(
                          key: const Key('add_edit_password_field'),
                          label: l10n.passwordLabel,
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          prefixIcon: LucideIcons.lock,
                          hint: l10n.hintPassword,
                          suffixIcon: IconButton(
                            key: const Key('add_edit_visibility_toggle'),
                            icon: Icon(
                              _obscurePassword
                                  ? LucideIcons.eye
                                  : LucideIcons.eyeOff,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          validator: (v) =>
                              v?.isEmpty == true ? l10n.errorOccurred : null,
                        ),
                        const SizedBox(height: AppSpacing.m),

                        // Extracted UI component for strength indication
                        if (_passwordController.text.isNotEmpty)
                          _PasswordStrengthIndicator(strength: state.strength),

                        const SizedBox(height: AppSpacing.l),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            key: const Key('add_edit_generate_button'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.m,
                              ),
                              side: BorderSide(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.m,
                                ),
                              ),
                            ),
                            onPressed: () {
                              context.read<AddEditPasswordBloc>().add(
                                GenerateStrongPassword(),
                              );
                            },
                            icon: const Icon(
                              LucideIcons.sparkles,
                              size: AppIconSize.s,
                            ),
                            label: Text(l10n.generate),
                          ),
                        ),
                      ],
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

/// Extracted widget for displaying password strength with semantic colors.
class _PasswordStrengthIndicator extends StatelessWidget {
  final double strength;

  const _PasswordStrengthIndicator({required this.strength});

  Color _getStrengthColor(BuildContext context) {
    final theme = context.theme;
    if (strength <= 0.25) return theme.strengthWeak;
    if (strength <= 0.5) return theme.strengthFair;
    if (strength <= 0.75) return theme.strengthGood;
    return theme.strengthStrong;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStrengthColor(context);

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xxs),
            child: LinearProgressIndicator(
              value: strength,
              backgroundColor: context.theme.securitySurface,
              color: color,
              minHeight: AppDimensions.passwordStrengthHeight,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Text(
          '${(strength * 100).toInt()}%',
          style: context.typography.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            fontFamily: context.theme.passwordText.fontFamily,
          ),
        ),
      ],
    );
  }
}
