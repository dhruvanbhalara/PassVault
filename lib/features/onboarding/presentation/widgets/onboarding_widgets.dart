import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

class IntroSlide extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const IntroSlide({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final iconSize = context.responsive(
      AppDimensions.onboardingIconSize,
      tablet: AppDimensions.onboardingIconSizeTablet,
      desktop: AppDimensions.onboardingIconSizeDesktop,
    );

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    context.responsive(AppSpacing.xxl, tablet: AppSpacing.xxxl),
                  ),
                  child: Icon(icon, size: iconSize, color: theme.primary),
                ),
              ),
              SizedBox(
                height: context.responsive(
                  AppSpacing.xxl,
                  tablet: AppSpacing.xxxl,
                ),
              ),
              Text(
                title,
                style: context.typography.headlineMedium?.copyWith(
                  color: theme.onVaultGradient,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                description,
                style: context.typography.bodyMedium?.copyWith(
                  color: theme.onVaultGradient.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IntroPaginationIndicator extends StatelessWidget {
  final int count;
  final int currentPage;

  const IntroPaginationIndicator({
    super.key,
    required this.count,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: AppDuration.normal,
          curve: AppCurves.standard,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          height: AppDimensions.indicatorSize,
          width: currentPage == index
              ? AppDimensions.indicatorWidthLarge
              : AppDimensions.indicatorSize,
          decoration: BoxDecoration(
            color: currentPage == index
                ? theme.primary
                : theme.onVaultGradient.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
      ),
    );
  }
}

class IntroNavigationButtons extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const IntroNavigationButtons({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final textTheme = context.typography;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Skip Button
        if (currentPage < totalPages - 1)
          TextButton(
            key: const Key('intro_skip_button'),
            onPressed: onSkip,
            child: Text(
              l10n.skip,
              style: textTheme.bodyMedium?.copyWith(
                color: theme.onVaultGradient,
              ),
            ),
          )
        else
          const SizedBox(width: AppSpacing.xxxl),

        // Progress Indicators
        IntroPaginationIndicator(count: totalPages, currentPage: currentPage),

        // Navigation Button (Next/Done)
        TextButton(
          key: const Key('intro_next_button'),
          onPressed: onNext,
          child: Text(
            currentPage == totalPages - 1 ? l10n.done : l10n.next,
            style: textTheme.titleMedium?.copyWith(
              color: theme.onVaultGradient,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
