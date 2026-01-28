import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/onboarding/presentation/widgets/intro_pagination_indicator.dart';

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
