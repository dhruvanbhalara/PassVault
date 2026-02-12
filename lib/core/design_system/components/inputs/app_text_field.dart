import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';

/// A Design System Input Field that encapsulates labeling, styling, and validation.
///
/// This atom unifies the input field experience by coupling the label with
/// the input decoration logic, ensuring consistent spacing and typography.
///
/// Example:
/// ```dart
/// AppTextField(
///   label: 'Username',
///   hint: 'Enter username',
///   controller: _controller,
///   prefixIcon: LucideIcons.user,
/// )
/// ```
/// A Design System Input Field that encapsulates labeling, styling, and validation.
///
/// This atom unifies the input field experience by coupling the label with
/// the input decoration logic, ensuring consistent spacing and typography.
class AppTextField extends StatelessWidget {
  /// The label displayed above the input field.
  final String label;

  /// The hint text displayed inside the input field when empty.
  final String? hint;

  /// The controller for the text field.
  final TextEditingController? controller;

  /// The validation function.
  final FormFieldValidator<String>? validator;

  /// The icon to display at the start of the field.
  final IconData? prefixIcon;

  /// The widget to display at the end of the field (e.g. visibility toggle).
  final Widget? suffixIcon;

  /// Whether to obscure the text (for passwords).
  final bool obscureText;

  /// The type of keyboard to display.
  final TextInputType? keyboardType;

  /// The action button on the keyboard.
  final TextInputAction? textInputAction;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  /// Whether to use the monospaced password text style.
  final bool usePasswordStyle;

  /// Whether to show a focus glow (useful for AMOLED).
  final bool hasFocusGlow;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.usePasswordStyle = false,
    this.hasFocusGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final typography = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs),
          child: Text(
            label.toUpperCase(),
            style: typography.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: theme.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          style: usePasswordStyle ? theme.passwordText : null,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: AppIconSize.m)
                : null,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
