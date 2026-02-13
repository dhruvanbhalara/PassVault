import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/onboarding/presentation/bloc/onboarding_bloc.dart';

class BiometricEnableButton extends StatelessWidget {
  const BiometricEnableButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          final isAuthenticating = state is BiometricAuthInProgress;
          return AppButton(
            key: const Key('intro_biometric_enable_button'),
            text: l10n.enableNow,
            isLoading: isAuthenticating,
            onPressed: isAuthenticating
                ? null
                : () => context.read<OnboardingBloc>().add(
                    BiometricAuthRequested(),
                  ),
          );
        },
      ),
    );
  }
}

class NavigationRow extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const NavigationRow({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textTheme = context.typography;
    final isLastPage = currentPage == totalPages - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.xl,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isLastPage)
            TextButton(
              key: const Key('intro_skip_button'),
              onPressed: onSkip,
              child: Text(
                l10n.skip,
                style: textTheme.bodyMedium?.copyWith(color: colors.secondary),
              ),
            )
          else
            const SizedBox(width: AppSpacing.xxxl),
          PageIndicators(currentPage: currentPage, totalPages: totalPages),
          TextButton(
            key: isLastPage
                ? const Key('intro_done_button')
                : const Key('intro_next_button'),
            onPressed: isLastPage ? onSkip : onNext,
            child: Text(
              isLastPage ? l10n.done : l10n.next,
              style: textTheme.titleMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageIndicators extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PageIndicators({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: AppDuration.normal,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          height: 8,
          width: currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentPage == index
                ? colors.primary
                : colors.secondary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
      ),
    );
  }
}

class BaseOnboardingSlide extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Animation<double> pulseAnimation;
  final Widget? footer;

  const BaseOnboardingSlide({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.pulseAnimation,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          ScaleTransition(
            scale: pulseAnimation,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Icon(icon, size: 80, color: context.colors.primary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            title,
            style: context.typography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            description,
            style: context.typography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.xl),
            footer!,
          ],
        ],
      ),
    );
  }
}

class PrivacyInfoCard extends StatelessWidget {
  final AppLocalizations l10n;

  const PrivacyInfoCard({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: colors.surfaceHighlight,
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(color: colors.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.lockKeyhole, size: 24, color: colors.primary),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Text(
              l10n.privacyNotice,
              style: context.typography.bodyMedium?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
