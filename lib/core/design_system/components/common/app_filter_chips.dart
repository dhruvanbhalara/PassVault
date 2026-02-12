import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

/// A horizontally scrollable row of single-selection filter chips.
///
/// Adapts styling across light, dark, and AMOLED themes using the design
/// system's [AppThemeExtension] tokens. Only one chip may be active at a time
/// (radio-like behavior).
///
/// Example:
/// ```dart
/// AppFilterChips(
///   labels: const ['All', 'Recently Added', 'Most Used', 'Favorites'],
///   selectedIndex: 0,
///   onSelected: (index) {
///     // Handle filter change
///   },
/// )
/// ```
class AppFilterChips extends StatelessWidget {
  /// The text labels for each chip.
  final List<String> labels;

  /// Index of the currently selected chip.
  final int selectedIndex;

  /// Called when a chip is tapped. Receives the tapped chip's index.
  final void Function(int)? onSelected;

  /// Outer padding around the entire scrollable row.
  ///
  /// Defaults to horizontal [AppSpacing.m] for visual breathing room.
  final EdgeInsetsGeometry? padding;

  const AppFilterChips({
    super.key,
    required this.labels,
    required this.selectedIndex,
    this.onSelected,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(labels.length, (index) {
          final isLast = index == labels.length - 1;
          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : AppSpacing.s),
            child: _FilterChip(
              label: labels[index],
              isSelected: index == selectedIndex,
              onTap: onSelected != null ? () => onSelected!(index) : null,
            ),
          );
        }),
      ),
    );
  }
}

/// An individual filter chip with animated color transitions, scale press
/// effect, AMOLED glow support, and accessibility semantics.
class _FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _isPressed = false;

  bool _isAmoled(AppThemeExtension theme) => theme.primaryGlow != null;

  Color _backgroundColor(AppThemeExtension theme, bool isDark) {
    if (widget.isSelected) {
      // Light: primary (#1976D2), Dark: secondary/teal (#26A69A),
      // AMOLED: primary (#2196F3)
      if (_isAmoled(theme)) return theme.primary;
      return isDark ? theme.secondary : theme.primary;
    }
    // Inactive backgrounds
    if (_isAmoled(theme)) return theme.background;
    return isDark ? theme.surfaceDim : theme.surfaceDim;
  }

  Color _foregroundColor(AppThemeExtension theme, bool isDark) {
    if (widget.isSelected) return theme.onPrimary;
    if (_isAmoled(theme)) return theme.onSurface;
    return isDark ? theme.onSurface.withValues(alpha: 0.7) : theme.onSurface;
  }

  Border? _border(AppThemeExtension theme) {
    if (!_isAmoled(theme)) return null;
    // AMOLED inactive: outlined white border; active: no visible border
    if (widget.isSelected) return null;
    return Border.all(color: theme.onSurface.withValues(alpha: 0.5));
  }

  List<BoxShadow>? _boxShadow(AppThemeExtension theme) {
    if (!_isAmoled(theme) || !widget.isSelected) return null;
    // Glow effect for active AMOLED chip
    final glow = theme.primaryGlow;
    return glow != null ? [glow] : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = context.isDarkMode;

    final bgColor = _backgroundColor(theme, isDark);
    final fgColor = _foregroundColor(theme, isDark);
    final border = _border(theme);
    final shadow = _boxShadow(theme);

    final l10n = context.l10n;
    final selectedLabel = widget.isSelected
        ? l10n.filterChipSelectedSemantics(widget.label)
        : l10n.filterChipSemantics(widget.label);

    return Semantics(
      label: selectedLabel,
      button: true,
      selected: widget.isSelected,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: _handleTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: AppDuration.fast,
          curve: AppCurves.standard,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: AppCurves.standard,
            constraints: const BoxConstraints(minHeight: AppSpacing.xxl),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadius.l),
              border: border,
              boxShadow: shadow,
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.typography.bodySmall?.copyWith(
                color: fgColor,
                fontWeight: widget.isSelected
                    ? FontWeight.w600
                    : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    if (widget.onTap == null) return;
    HapticFeedback.selectionClick();
    widget.onTap!();
  }
}
