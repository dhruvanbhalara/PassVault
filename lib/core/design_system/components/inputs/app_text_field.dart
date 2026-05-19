import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';

/// A premium Input Field that encapsulates labeling, styling, and focus glows.
///
/// This atom provides:
/// - Focused glow effects (Obsidian Emerald).
/// - Integrated password style support.
class AppTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final bool usePasswordStyle;

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
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.m),
            boxShadow: _isFocused && theme.focusGlow != null
                ? [theme.focusGlow!]
                : null,
          ),
          child: TextFormField(
            focusNode: _focusNode,
            controller: widget.controller,
            validator: widget.validator,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            style: widget.usePasswordStyle
                ? theme.passwordText
                : context.typography.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hint,
              labelText: widget.label,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, size: AppIconSize.m)
                  : null,
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: theme.surfaceDim.withValues(alpha: 0.5),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.m),
                borderSide: BorderSide(color: theme.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.m),
                borderSide: BorderSide(color: theme.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.m),
                borderSide: BorderSide(color: theme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.m),
                borderSide: BorderSide(color: theme.error, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
