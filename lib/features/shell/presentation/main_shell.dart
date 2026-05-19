import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  bool _isNavVisible = true;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // Reserve space for the floating bar (60 height + 16 bottom padding + extra buffer)
    const reserveSpace = kBottomNavigationBarHeight + AppSpacing.m;

    return Scaffold(
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse) {
            if (_isNavVisible) setState(() => _isNavVisible = false);
          } else if (notification.direction == ScrollDirection.forward) {
            if (!_isNavVisible) setState(() => _isNavVisible = true);
          }
          return false;
        },
        child: Stack(
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

            // Floating Navigation Bar
            AnimatedPositioned(
              duration: AppDuration.normal,
              curve: AppCurves.emphasizeEntrance,
              left: 0,
              right: 0,
              bottom: _isNavVisible ? 0 : -reserveSpace - 20,
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
      ),
    );
  }

  void _onTabTapped(BuildContext context, int index) {
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
    final themeType = _resolveThemeType(context);
    final l10n = context.l10n;
    const itemCount = 3;

    return SizedBox(
      height: kBottomNavigationBarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        child: DecoratedBox(
          decoration: _buildDecoration(colors, themeType),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: ColoredBox(
              color: colors.surface,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / itemCount;
                  // Premium Fluid Pill Indicator
                  final indicatorWidth = itemWidth * 0.7;
                  const indicatorHeight = 40.0;
                  final indicatorOffset =
                      (itemWidth - indicatorWidth) / 2 +
                      itemWidth * currentIndex;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedPositioned(
                        duration: AppDuration.normal,
                        curve: AppCurves.emphasizeEntrance,
                        left: indicatorOffset,
                        child: Center(
                          child: Container(
                            width: indicatorWidth,
                            height: indicatorHeight,
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                              boxShadow: [
                                if (colors.navIndicatorShadow != null)
                                  colors.navIndicatorShadow!,
                              ],
                            ),
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
                            inactiveColor: colors.bottomNavInactiveIcon,
                            onTap: () => onTap(0),
                          ),
                          _NavItem(
                            width: itemWidth,
                            icon: LucideIcons.shield,
                            semanticsLabel: l10n.tabSemanticsLabel(
                              l10n.generator,
                            ),
                            isActive: currentIndex == 1,
                            activeColor: colors.primary,
                            inactiveColor: colors.bottomNavInactiveIcon,
                            onTap: () => onTap(1),
                          ),
                          _NavItem(
                            width: itemWidth,
                            icon: LucideIcons.settings,
                            semanticsLabel: l10n.tabSemanticsLabel(
                              l10n.settings,
                            ),
                            isActive: currentIndex == 2,
                            activeColor: colors.primary,
                            inactiveColor: colors.bottomNavInactiveIcon,
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
        ),
      ),
    );
  }

  ThemeType _resolveThemeType(BuildContext context) {
    final state = context.read<ThemeBloc>().state;
    return switch (state) {
      ThemeLoaded(:final themeType) => themeType,
    };
  }

  BoxDecoration _buildDecoration(
    AppThemeExtension colors,
    ThemeType themeType,
  ) {
    final borderRadius = BorderRadius.circular(AppRadius.full);

    switch (themeType) {
      case ThemeType.amoled:
        return BoxDecoration(
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
              offset: Offset(0, isActive ? -0.05 : 0),
              child: AnimatedScale(
                duration: AppDuration.normal,
                curve: AppCurves.standard,
                scale: isActive ? 1.1 : 1,
                child: Icon(icon, size: 24, color: color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
