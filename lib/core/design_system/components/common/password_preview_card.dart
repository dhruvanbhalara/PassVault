import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';
import 'package:password_engine/password_engine.dart' show PasswordStrength;

/// A performance-optimized, premium card for previewing generated passwords.
/// Uses [RepaintBoundary] to isolate animations and follows strict CLEAN UI standards.
class PasswordPreviewCard extends StatelessWidget {
  final String password;
  final PasswordFeedback strength;
  final VoidCallback? onRefresh;
  final VoidCallback? onCopy;
  final bool isLoading;
  final String? label;

  const PasswordPreviewCard({
    super.key,
    required this.password,
    required this.strength,
    this.onRefresh,
    this.onCopy,
    this.isLoading = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final strengthColor = _getStrengthColor(strength.strength, theme);
    final foregroundColor = _getAdaptiveForegroundColor(
      strength.strength,
      theme,
    );

    return RepaintBoundary(
      child: _CardBackground(
        strengthColor: strengthColor,
        theme: theme,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.l,
                children: [
                  _CardHeader(
                    label: label,
                    strength: strength.strength,
                    foregroundColor: foregroundColor,
                  ),
                  _CardContent(
                    password: password,
                    foregroundColor: foregroundColor,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
            _ActionButtons(
              onRefresh: onRefresh,
              onCopy: onCopy,
              foregroundColor: foregroundColor,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }

  static Color _getStrengthColor(
    PasswordStrength strength,
    AppThemeExtension theme,
  ) {
    return switch (strength) {
      PasswordStrength.veryWeak => theme.strengthVeryWeak,
      PasswordStrength.weak => theme.strengthWeak,
      PasswordStrength.medium => theme.strengthFair,
      PasswordStrength.strong => theme.strengthStrong,
      PasswordStrength.veryStrong => theme.strengthVeryStrong,
    };
  }

  static Color _getAdaptiveForegroundColor(
    PasswordStrength strength,
    AppThemeExtension theme,
  ) {
    final bgColor = _getStrengthColor(strength, theme);
    if (strength == PasswordStrength.medium) {
      return Colors.black.withValues(alpha: 0.85);
    }
    return bgColor.computeLuminance() > 0.45
        ? Colors.black.withValues(alpha: 0.85)
        : Colors.white;
  }
}

class _CardBackground extends StatelessWidget {
  final Color strengthColor;
  final AppThemeExtension theme;
  final Widget child;

  const _CardBackground({
    required this.strengthColor,
    required this.theme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              strengthColor,
              Color.lerp(strengthColor, Colors.black, 0.12)!,
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            theme.cardShadow,
            BoxShadow(
              color: strengthColor.withValues(alpha: 0.2),
              blurRadius: 30,
              spreadRadius: -8,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String? label;
  final PasswordStrength strength;
  final Color foregroundColor;

  const _CardHeader({
    this.label,
    required this.strength,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.typography;
    final displayLabel = label ?? l10n.preview.toUpperCase();
    final strengthText = _getStrengthText(strength, l10n);

    return Row(
      children: [
        Text(
          displayLabel,
          style: textTheme.labelSmall?.copyWith(
            color: foregroundColor.withValues(alpha: 0.6),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: foregroundColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text(
            strengthText.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w900,
              fontSize: 9,
            ),
          ),
        ),
      ],
    );
  }

  String _getStrengthText(PasswordStrength strength, AppLocalizations l10n) {
    return switch (strength) {
      PasswordStrength.veryWeak => l10n.strengthVeryWeak,
      PasswordStrength.weak => l10n.strengthWeak,
      PasswordStrength.medium => l10n.strengthFair,
      PasswordStrength.strong => l10n.strengthStrong,
      PasswordStrength.veryStrong => l10n.strengthVeryStrong,
    };
  }
}

class _CardContent extends StatelessWidget {
  final String password;
  final Color foregroundColor;
  final bool isLoading;

  const _CardContent({
    required this.password,
    required this.foregroundColor,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return RepaintBoundary(
      child: SizedBox(
        width: double.infinity,
        child: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation, secondaryAnimation) =>
              FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                fillColor: Colors.transparent,
                child: child,
              ),
          child: isLoading
              ? _LoadingPlaceholder(color: foregroundColor)
              : _PasswordText(
                  password: password,
                  foregroundColor: foregroundColor,
                  theme: theme,
                ),
        ),
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  final Color color;
  const _LoadingPlaceholder({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('preview_loading'),
      height: 40,
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}

class _PasswordText extends StatelessWidget {
  final String password;
  final Color foregroundColor;
  final AppThemeExtension theme;

  const _PasswordText({
    required this.password,
    required this.foregroundColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableText(
          password,
          key: ValueKey('pwd_$password'),
          maxLines: 5,
          minLines: 4,
          style: theme.passwordText.copyWith(
            fontSize: 20,
            color: foregroundColor,
            height: 1.3,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback? onRefresh;
  final VoidCallback? onCopy;
  final Color foregroundColor;
  final bool isLoading;

  const _ActionButtons({
    this.onRefresh,
    this.onCopy,
    required this.foregroundColor,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.m,
      right: AppSpacing.m,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onRefresh != null)
            _ActionIcon(
              key: const Key('preview_refresh'),
              icon: LucideIcons.refreshCw,
              onTap: onRefresh!,
              color: foregroundColor,
              isLoading: isLoading,
              isRotating: true,
            ),
          if (onCopy != null) ...[
            const SizedBox(width: AppSpacing.xs),
            _ActionIcon(
              key: const Key('preview_copy'),
              icon: LucideIcons.copy,
              onTap: onCopy!,
              color: foregroundColor,
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final bool isLoading;
  final bool isRotating;

  const _ActionIcon({
    super.key,
    required this.icon,
    required this.onTap,
    required this.color,
    this.isLoading = false,
    this.isRotating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s),
          child: Icon(icon, color: color, size: 20)
              .animate(
                target: (isLoading && isRotating) ? 1 : 0,
                onPlay: (controller) => controller.repeat(),
              )
              .rotate(duration: 1.seconds),
        ),
      ),
    );
  }
}
