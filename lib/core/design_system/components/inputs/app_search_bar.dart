import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';
import 'package:passvault/core/utils/haptics.dart';

/// A reusable search bar component that follows the PassVault design system.
///
/// Provides a consistent search experience across all screens with proper
/// theme integration (light, dark, AMOLED), debounced callbacks, accessibility,
/// and haptic feedback.
///
/// Example:
/// ```dart
/// AppSearchBar(
///   hintText: 'Search passwords...',
///   onChanged: (query) => bloc.add(SearchChanged(query)),
///   autofocus: true,
/// )
/// ```
class AppSearchBar extends StatefulWidget {
  /// Placeholder text shown when the field is empty.
  /// Defaults to "Search passwords...".
  final String? hintText;

  /// Debounced callback fired when the search text changes.
  /// Debounce delay is controlled by [debounceDuration].
  final ValueChanged<String>? onChanged;

  /// Callback fired when the user submits the search (keyboard action).
  final ValueChanged<String>? onSubmitted;

  /// External controller for the search text field.
  /// If not provided, an internal controller is created and managed.
  final TextEditingController? controller;

  /// External focus node for the search text field.
  /// If not provided, an internal focus node is created and managed.
  final FocusNode? focusNode;

  /// Whether the search field should request focus on mount.
  final bool autofocus;

  /// Outer padding around the search bar container.
  final EdgeInsetsGeometry? padding;

  /// Duration for debouncing [onChanged] callbacks.
  /// Defaults to 300ms.
  final Duration debounceDuration;

  const AppSearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.padding,
    this.debounceDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounceTimer;
  bool _hasFocus = false;

  bool get _isExternalController => widget.controller != null;
  bool get _isExternalFocusNode => widget.focusNode != null;
  bool get _hasText => _controller.text.isNotEmpty;

  // --------------------------------------------------------------------------
  // Theme helpers
  // --------------------------------------------------------------------------

  /// Whether the current theme is AMOLED (pure black with glow effects).
  bool _isAmoled(AppThemeExtension theme) => theme.primaryGlow != null;

  Color _backgroundColor(AppThemeExtension theme) => theme.surfaceDim;

  Color _textColor(AppThemeExtension theme) => theme.onSurface;

  Color _iconColor(AppThemeExtension theme) {
    if (_isAmoled(theme)) return theme.onSurface;
    return theme.onSurface.withValues(alpha: 0.7);
  }

  Color _hintColor(AppThemeExtension theme) => _iconColor(theme);

  Color _focusBorderColor(AppThemeExtension theme) => theme.inputFocusedBorder;

  // --------------------------------------------------------------------------
  // Lifecycle
  // --------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant AppSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      if (!_isExternalController) {
        oldWidget.controller?.removeListener(_onTextChanged);
      }
      _controller.removeListener(_onTextChanged);
      if (widget.controller != null) {
        _controller = widget.controller!;
      }
      _controller.addListener(_onTextChanged);
    }

    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_onFocusChanged);
      if (widget.focusNode != null) {
        _focusNode = widget.focusNode!;
      }
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onTextChanged);
    if (!_isExternalController) _controller.dispose();
    _focusNode.removeListener(_onFocusChanged);
    if (!_isExternalFocusNode) _focusNode.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // Handlers
  // --------------------------------------------------------------------------

  void _onTextChanged() {
    // Rebuild to toggle clear button visibility.
    setState(() {});
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onChanged?.call(_controller.text);
    });
  }

  void _onFocusChanged() {
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  Future<void> _onClear() async {
    await AppHaptics.lightImpact();
    _controller.clear();
    // Fire onChanged immediately on clear.
    _debounceTimer?.cancel();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  // --------------------------------------------------------------------------
  // Build
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isAmoled = _isAmoled(theme);

    return Semantics(
      label: context.l10n.searchPasswordsSemantics,
      textField: true,
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          constraints: const BoxConstraints(minHeight: 48),
          decoration: _buildDecoration(theme, isAmoled),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            textInputAction: TextInputAction.search,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.text,
            cursorColor: theme.primary,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: _textColor(theme)),
            decoration: _buildInputDecoration(theme),
            onSubmitted: widget.onSubmitted,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(AppThemeExtension theme, bool isAmoled) {
    final focusBorder = _focusBorderColor(theme);

    if (isAmoled) {
      return BoxDecoration(
        color: _backgroundColor(theme),
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(
          color: _hasFocus
              ? focusBorder
              : theme.onSurface.withValues(alpha: 0.3),
          width: _hasFocus ? 1.5 : 1.0,
        ),
        boxShadow: _hasFocus && theme.primaryGlow != null
            ? [theme.primaryGlow!]
            : null,
      );
    }

    return BoxDecoration(
      color: _backgroundColor(theme),
      borderRadius: BorderRadius.circular(AppRadius.m),
      border: _hasFocus ? Border.all(color: focusBorder, width: 1.5) : null,
    );
  }

  InputDecoration _buildInputDecoration(AppThemeExtension theme) {
    final iconColor = _iconColor(theme);

    return InputDecoration(
      hintText: widget.hintText ?? context.l10n.searchPasswords,
      hintStyle: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: _hintColor(theme)),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.s + AppSpacing.xs,
        horizontal: AppSpacing.m,
      ),
      prefixIcon: Icon(
        LucideIcons.search,
        size: AppIconSize.l,
        color: iconColor,
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      suffixIcon: _hasText
          ? Semantics(
              label: context.l10n.clearSearch,
              button: true,
              child: IconButton(
                icon: Icon(
                  LucideIcons.x,
                  size: AppIconSize.l,
                  color: iconColor,
                ),
                onPressed: _onClear,
                tooltip: context.l10n.clearSearch,
              ),
            )
          : null,
      suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    );
  }
}
