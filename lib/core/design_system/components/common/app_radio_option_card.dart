import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

/// A tappable radio-style option card with icon, title, description, and
/// optional badge.
///
/// Designed for the Export Vault screen where the user picks among exclusive
/// format options (e.g. encrypted, JSON, CSV).
///
/// Example:
/// ```dart
/// AppRadioOptionCard(
///   icon: Icons.lock,
///   title: 'Encrypted Vault',
///   description: 'AES-256 encrypted, password protected',
///   badgeText: 'Recommended',
///   badgeColor: Colors.green,
///   isSelected: selectedFormat == ExportFormat.encrypted,
///   onTap: () => setState(() => selectedFormat = ExportFormat.encrypted),
/// )
/// ```
class AppRadioOptionCard extends StatefulWidget {
  /// Leading icon displayed beside the radio indicator.
  final IconData icon;

  /// Primary label for the option.
  final String title;

  /// Secondary descriptive text.
  final String description;

  /// Whether this option is the currently selected one.
  final bool isSelected;

  /// Called when the entire card is tapped.
  final VoidCallback? onTap;

  /// Optional badge label (e.g. "Recommended"). Hidden when null.
  final String? badgeText;

  /// Badge accent color. Falls back to [AppThemeExtension.success] when null.
  final Color? badgeColor;

  const AppRadioOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    this.onTap,
    this.badgeText,
    this.badgeColor,
  });

  @override
  State<AppRadioOptionCard> createState() => _AppRadioOptionCardState();
}

class _AppRadioOptionCardState extends State<AppRadioOptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  /// Tracks the previous selection state so haptic feedback only fires on
  /// actual change.
  bool _previousSelected = false;

  bool get _isAmoled => context.theme.primaryGlow != null;

  @override
  void initState() {
    super.initState();
    _previousSelected = widget.isSelected;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: AppCurves.standard));
  }

  @override
  void didUpdateWidget(covariant AppRadioOptionCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSelected != oldWidget.isSelected) {
      // Fire haptic only on actual state change.
      if (widget.isSelected && !_previousSelected) {
        HapticFeedback.selectionClick();
      }
      _previousSelected = widget.isSelected;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();

  void _onTapUp(TapUpDetails _) => _controller.reverse();

  void _onTapCancel() => _controller.reverse();

  void _onTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = context.colorScheme;
    final typography = context.typography;
    final isAmoled = _isAmoled;

    final borderColor = widget.isSelected
        ? theme.primary
        : isAmoled
        ? theme.onSurface.withValues(alpha: 0.15)
        : theme.outline;

    final borderWidth = widget.isSelected ? 2.0 : 1.0;

    final cardColor = isAmoled ? theme.background : theme.surface;

    final selectedShadows = _buildSelectedShadows(theme, isAmoled);

    return Semantics(
      toggled: widget.isSelected,
      button: true,
      label: _buildSemanticLabel(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: AppCurves.standard,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(AppRadius.m),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: widget.isSelected ? selectedShadows : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: theme.surface.withValues(alpha: 0),
            child: InkWell(
              onTap: widget.onTap != null ? _onTap : null,
              onTapDown: widget.onTap != null ? _onTapDown : null,
              onTapUp: widget.onTap != null ? _onTapUp : null,
              onTapCancel: widget.onTap != null ? _onTapCancel : null,
              borderRadius: BorderRadius.circular(AppRadius.m),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Row(
                  children: [
                    // Radio indicator
                    ExcludeSemantics(
                      child: Icon(
                        widget.isSelected
                            ? LucideIcons.circleDot
                            : LucideIcons.circle,
                        size: AppIconSize.l,
                        color: widget.isSelected
                            ? theme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    // Option icon
                    ExcludeSemantics(
                      child: Icon(
                        widget.icon,
                        size: AppIconSize.l,
                        color: widget.isSelected
                            ? theme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    // Title + description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: typography.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: theme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.badgeText != null) ...[
                                const SizedBox(width: AppSpacing.s),
                                _Badge(
                                  text: widget.badgeText!,
                                  color: widget.badgeColor ?? theme.success,
                                  isAmoled: isAmoled,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            widget.description,
                            style: typography.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _buildSemanticLabel() {
    final l10n = context.l10n;
    final buffer = StringBuffer(
      '${l10n.radioButtonSemanticsPrefix}, ${widget.title}',
    );
    buffer.write(', ${widget.description}');
    if (widget.badgeText != null) buffer.write(', ${widget.badgeText}');
    buffer.write(
      widget.isSelected
          ? ', ${l10n.selectedState}'
          : ', ${l10n.notSelectedState}',
    );
    return buffer.toString();
  }

  List<BoxShadow> _buildSelectedShadows(
    AppThemeExtension theme,
    bool isAmoled,
  ) {
    if (isAmoled) {
      // Neon glow on AMOLED
      return [
        BoxShadow(
          color: theme.primary.withValues(alpha: 0.35),
          blurRadius: 12,
          spreadRadius: 1,
        ),
      ];
    }

    if (context.isDarkMode) {
      // Subtle elevation for dark mode
      return [
        BoxShadow(
          color: theme.primary.withValues(alpha: 0.15),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    }

    // Light mode – subtle shadow
    return [
      BoxShadow(
        color: theme.primary.withValues(alpha: 0.12),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ];
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final bool isAmoled;

  const _Badge({
    required this.text,
    required this.color,
    required this.isAmoled,
  });

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    if (isAmoled) {
      // AMOLED: outlined badge with neon glow
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.s),
          border: Border.all(color: color.withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.30),
              blurRadius: 6,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Text(
          text,
          style: typography.labelSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      );
    }

    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? color.withValues(alpha: 0.15)
            : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Text(
        text,
        style: typography.labelSmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: isDark ? color.withValues(alpha: 0.9) : color,
        ),
      ),
    );
  }
}
