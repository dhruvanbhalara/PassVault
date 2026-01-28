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
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.copy, size: AppIconSize.s),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Text(
                  duplicate.existingEntry.appName,
                  style: context.typography.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${context.l10n.usernameLabel}: ${duplicate.existingEntry.username}',
            style: context.typography.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Container(
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              color: context.theme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.s),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.info,
                  size: AppIconSize.xs,
                  color: context.theme.error,
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Text(
                    duplicate.conflictReason,
                    style: context.typography.bodySmall?.copyWith(
                      color: context.theme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          ResolutionChoiceButtons(
            selectedChoice: duplicate.userChoice,
            onChoiceChanged: onChoiceChanged,
          ),
        ],
      ),
    );
  }
}
