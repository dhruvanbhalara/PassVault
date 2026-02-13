import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';

/// Persistent bottom navigation shell that wraps the three main tabs:
/// Home (vault list), Generator, and Settings.
///
/// Uses [StatefulNavigationShell] from go_router to preserve each tab's
/// navigation stack when switching between tabs.
class MainShell extends StatefulWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final ValueNotifier<bool> _isVisibleNotifier = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _isVisibleNotifier.dispose();
    super.dispose();
  }

  void _onScroll(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse &&
          _isVisibleNotifier.value) {
        _isVisibleNotifier.value = false;
      } else if (notification.direction == ScrollDirection.forward &&
          !_isVisibleNotifier.value) {
        _isVisibleNotifier.value = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // Reserve space for the floating bar (60 height + 16 bottom padding + extra buffer)
    const reserveSpace = 112.0;

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _onScroll(notification);
          return false;
        },
        child: Stack(
          children: [
            // Background Content - No longer rebuilds on navbar toggle
            MediaQuery(
              data: mediaQuery.copyWith(
                padding: mediaQuery.padding.copyWith(
                  bottom: mediaQuery.padding.bottom + reserveSpace,
                ),
                viewPadding: mediaQuery.viewPadding.copyWith(
                  bottom: mediaQuery.viewPadding.bottom + reserveSpace,
                ),
              ),
              child: widget.navigationShell,
            ),

            // Floating Navigation Bar - Only this part rebuilds
            ValueListenableBuilder<bool>(
              valueListenable: _isVisibleNotifier,
              builder: (context, isVisible, child) {
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: 0,
                  right: 0,
                  bottom: isVisible ? 0 : -reserveSpace,
                  child: child!,
                );
              },
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: _BottomNavBar(
                        currentIndex: widget.navigationShell.currentIndex,
                        onTap: (index) => _onTabTapped(context, index),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTabTapped(BuildContext context, int index) {
    // If tapping the already-active tab, navigate to the initial location
    // of that branch (effectively "scroll to top" / pop to root).
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}

/// The themed bottom navigation bar with Home, Generator, and Settings tabs.
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme;
    final isAmoled = context.isAmoled;
    final themeType = _resolveThemeType(context);
    final l10n = context.l10n;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
      decoration: _buildDecoration(colors, themeType),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NavItem(
            icon: LucideIcons.house,
            semanticsLabel: l10n.tabSemanticsLabel(l10n.vault),
            isActive: currentIndex == 0,
            activeColor: colors.primary,
            inactiveColor: _inactiveColor(colors, isAmoled),
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: LucideIcons.shield,
            semanticsLabel: l10n.tabSemanticsLabel(l10n.generator),
            isActive: currentIndex == 1,
            activeColor: colors.primary,
            inactiveColor: _inactiveColor(colors, isAmoled),
            onTap: () => onTap(1),
          ),
          _NavItem(
            icon: LucideIcons.settings,
            semanticsLabel: l10n.tabSemanticsLabel(l10n.settings),
            isActive: currentIndex == 2,
            activeColor: colors.primary,
            inactiveColor: _inactiveColor(colors, isAmoled),
            onTap: () => onTap(2),
          ),
        ],
      ),
    );
  }

  /// Returns the inactive icon color based on brightness.
  Color _inactiveColor(AppThemeExtension colors, bool isAmoled) {
    return colors.onSurface.withValues(alpha: isAmoled ? 0.8 : 0.6);
  }

  /// Resolves the current [ThemeType] from the [ThemeBloc] state.
  ThemeType _resolveThemeType(BuildContext context) {
    final state = context.read<ThemeBloc>().state;
    return switch (state) {
      ThemeLoaded(:final themeType) => themeType,
    };
  }

  /// Builds the container decoration per theme variant:
  /// - Light: 8dp elevation shadow
  /// - Dark: top border, no elevation
  /// - AMOLED: top border with glow accent
  BoxDecoration _buildDecoration(
    AppThemeExtension colors,
    ThemeType themeType,
  ) {
    final borderRadius = BorderRadius.circular(AppRadius.full);

    switch (themeType) {
      case ThemeType.amoled:
        return BoxDecoration(
          color: colors.background,
          borderRadius: borderRadius,
          border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case ThemeType.dark:
        return BoxDecoration(
          color: colors.surface,
          borderRadius: borderRadius,
          border: Border.all(color: colors.outline.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case ThemeType.light:
      case ThemeType.system:
        return BoxDecoration(
          color: colors.surface,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: colors.cardShadow.color.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );
    }
  }
}

/// A single bottom navigation item with icon and label.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.semanticsLabel,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final IconData icon;
  final String semanticsLabel;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : inactiveColor;

    return Semantics(
      label: semanticsLabel,
      selected: isActive,
      button: true,
      child: InkResponse(
        onTap: onTap,
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        child: SizedBox(
          height: 60,
          width: 80,
          child: Center(child: Icon(icon, size: 24, color: color)),
        ),
      ),
    );
  }
}
