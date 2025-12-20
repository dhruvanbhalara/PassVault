import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/core/theme/app_colors.dart';
import 'package:passvault/core/theme/design_system.dart';
import 'package:passvault/features/home/presentation/bloc/password_bloc.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/features/password_manager/presentation/bloc/add_edit_password_bloc.dart';
import 'package:passvault/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

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

/// Internal view widget for AddEditPasswordScreen.
/// Exposed for testing purposes only.
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

  // Track the last applied generated password to prevent re-application
  // This fixes the bug where editing after generating would revert to generated password
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

    // Initial strength check
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

  void _save(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final entry = PasswordEntry(
        id:
            widget.entry?.id ??
            const Uuid().v4(), // Need uuid package or unique generation
        appName: _appNameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        lastUpdated: DateTime.now(),
      );

      // Use getIt instead of context.read since PasswordBloc is on a different route
      getIt<PasswordBloc>().add(
        widget.entry == null ? AddPassword(entry) : UpdatePassword(entry),
      );
      Navigator.of(context).pop();
    }
  }

  Color _getStrengthColor(double strength) {
    if (strength <= 0.25) return AppColors.strengthWeak;
    if (strength <= 0.5) return AppColors.strengthFair;
    if (strength <= 0.75) return AppColors.strengthGood;
    return AppColors.strengthStrong;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocConsumer<AddEditPasswordBloc, AddEditPasswordState>(
      listener: (context, state) {
        // Only apply the generated password if:
        // 1. Status is 'generated'
        // 2. We haven't already applied this specific generated password
        // This prevents overwriting user's manual edits
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
        final strength = state.strength;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.entry == null ? l10n.addPassword : l10n.editPassword,
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            key: const Key('add_edit_save_button'),
            onPressed: () => _save(context),
            icon: const Icon(LucideIcons.save),
            label: Text(l10n.save),
          ),
          body: SingleChildScrollView(
            padding: DesignSystem.paddingPage,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LabeledInputField(
                    title: l10n.appNameLabel,
                    child: TextFormField(
                      key: const Key('add_edit_app_name_field'),
                      controller: _appNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: l10n.hintAppName,
                        prefixIcon: const Icon(LucideIcons.globe),
                      ),
                      validator: (v) =>
                          v?.isEmpty == true ? l10n.errorOccurred : null,
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacingL),
                  LabeledInputField(
                    title: l10n.usernameLabel,
                    child: TextFormField(
                      key: const Key('add_edit_username_field'),
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: l10n.hintUsername,
                        prefixIcon: const Icon(LucideIcons.atSign),
                      ),
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacingL),
                  LabeledInputField(
                    title: l10n.passwordLabel,
                    child: Column(
                      children: [
                        TextFormField(
                          key: const Key('add_edit_password_field'),
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: l10n.hintPassword,
                            prefixIcon: const Icon(LucideIcons.lock),
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
                          ),
                          validator: (v) =>
                              v?.isEmpty == true ? l10n.errorOccurred : null,
                        ),
                        const SizedBox(height: DesignSystem.spacingM),
                        // Strength Indicator from BLoC state
                        if (_passwordController.text.isNotEmpty)
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(2),
                                  child: LinearProgressIndicator(
                                    value: strength,
                                    backgroundColor: theme
                                        .colorScheme
                                        .outlineVariant
                                        .withValues(alpha: 0.2),
                                    color: _getStrengthColor(strength),
                                    minHeight: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${(strength * 100).toInt()}%",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: _getStrengthColor(strength),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: DesignSystem.spacingL),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            key: const Key('add_edit_generate_button'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: DesignSystem.borderRadiusM,
                              ),
                            ),
                            onPressed: () {
                              context.read<AddEditPasswordBloc>().add(
                                GenerateStrongPassword(),
                              );
                            },
                            icon: const Icon(LucideIcons.sparkles, size: 18),
                            label: Text(l10n.generate),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80), // Fab spacing
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A labeled input field widget that displays a title above the child widget.
/// Used for form fields with consistent styling across the app.
class LabeledInputField extends StatelessWidget {
  final String title;
  final Widget child;

  const LabeledInputField({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
