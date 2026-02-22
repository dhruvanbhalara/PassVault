import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/app_animations.dart';
import 'package:passvault/core/design_system/theme/app_dimensions.dart';
import 'package:passvault/core/design_system/theme/app_theme_extension.dart';
import 'package:passvault/features/settings/domain/entities/theme_type.dart';
import 'package:passvault/features/settings/presentation/bloc/theme/theme_bloc.dart';

class MainShell extends StatefulWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // Reserve space for the floating bar (60 height + 16 bottom padding + extra buffer)
    const reserveSpace = kBottomNavigationBarHeight + AppSpacing.m;

    return Scaffold(
      body: Stack(
        children: [
          // Background Content
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

          // Floating Navigation Bar (Permanently Visible)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.m,
                  0,
                  AppSpacing.m,
                  AppSpacing.m,
                ),
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
    const itemCount = 3;

    return SizedBox(
      height: kBottomNavigationBarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        child: DecoratedBox(
          decoration: _buildDecoration(colors, themeType),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / itemCount;
              const indicatorSize = AppIconSize.xxxl;
              final indicatorOffset =
                  (itemWidth - indicatorSize) / 2 + itemWidth * currentIndex;

              return Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedPositioned(
                    duration: AppDuration.slow,
                    curve: AppCurves.emphasizeEntrance,
                    left: indicatorOffset,
                    child: Container(
                      width: indicatorSize,
                      height: indicatorSize,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _NavItem(
                        width: itemWidth,
                        icon: LucideIcons.house,
                        semanticsLabel: l10n.tabSemanticsLabel(l10n.vault),
                        isActive: currentIndex == 0,
                        activeColor: colors.primary,
                        inactiveColor: _inactiveColor(colors, isAmoled),
                        onTap: () => onTap(0),
                      ),
                      _NavItem(
                        width: itemWidth,
                        icon: LucideIcons.shield,
                        semanticsLabel: l10n.tabSemanticsLabel(l10n.generator),
                        isActive: currentIndex == 1,
                        activeColor: colors.primary,
                        inactiveColor: _inactiveColor(colors, isAmoled),
                        onTap: () => onTap(1),
                      ),
                      _NavItem(
                        width: itemWidth,
                        icon: LucideIcons.settings,
                        semanticsLabel: l10n.tabSemanticsLabel(l10n.settings),
                        isActive: currentIndex == 2,
                        activeColor: colors.primary,
                        inactiveColor: _inactiveColor(colors, isAmoled),
                        onTap: () => onTap(2),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
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
              color: colors.cardShadow.color.withValues(alpha: 0.35),
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
    required this.width,
    required this.icon,
    required this.semanticsLabel,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final double width;
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
          height: kBottomNavigationBarHeight,
          width: width,
          child: Center(
            child: AnimatedSlide(
              duration: AppDuration.normal,
              curve: AppCurves.standard,
              offset: Offset(0, isActive ? -0.08 : 0),
              child: AnimatedScale(
                duration: AppDuration.normal,
                curve: AppCurves.standard,
                scale: isActive ? 1.15 : 1,
                child: Icon(icon, size: 24, color: color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
