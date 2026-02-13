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
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
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
                        context.responsive(
                          AppSpacing.xxl,
                          tablet: AppSpacing.xxxl,
                        ),
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
        ],
      ),
    );
  }
}
