import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';

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
