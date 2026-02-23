import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/presentation/widgets/resolution_choice_buttons.dart';

class DuplicateCard extends StatelessWidget {
  final DuplicatePasswordEntry duplicate;
  final ValueChanged<DuplicateResolutionChoice> onChoiceChanged;

  const DuplicateCard({
    super.key,
    required this.duplicate,
    required this.onChoiceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isAmoled = theme.primaryGlow != null;

    return AppCard(
      hasGlow: isAmoled && duplicate.userChoice != null,
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: theme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.s),
                ),
                child: Icon(LucideIcons.copy, size: 16, color: theme.primary),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      duplicate.existingEntry.appName,
                      style: context.typography.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      duplicate.existingEntry.username,
                      style: context.typography.bodySmall?.copyWith(
                        color: theme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              color: theme.error.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppRadius.m),
              border: Border.all(color: theme.error.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.info, size: 16, color: theme.error),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    duplicate.conflictReason,
                    style: context.typography.bodySmall?.copyWith(
                      color: theme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.l),
          ResolutionChoiceButtons(
            selectedChoice: duplicate.userChoice,
            onChoiceChanged: onChoiceChanged,
          ),
        ],
      ),
    );
  }
}
