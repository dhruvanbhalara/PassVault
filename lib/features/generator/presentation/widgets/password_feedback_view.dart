import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/password_feedback.dart';

class PasswordFeedbackView extends StatelessWidget {
  final PasswordFeedback feedback;

  const PasswordFeedbackView({super.key, required this.feedback});

  bool get _hasContent =>
      (feedback.warning?.isNotEmpty ?? false) ||
      feedback.suggestions.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!_hasContent) {
      return const SizedBox.shrink();
    }

    final typography = context.typography;
    final theme = context.theme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppSpacing.m),
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: theme.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(color: theme.warning.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.s,
        children: [
          if (feedback.warning?.isNotEmpty ?? false)
            Text(
              feedback.warning!,
              style: typography.bodySmall?.copyWith(
                color: theme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ...feedback.suggestions
              .take(3)
              .map(
                (suggestion) => Text(
                  suggestion,
                  style: typography.bodySmall?.copyWith(
                    color: theme.onSurface.withValues(alpha: 0.85),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
