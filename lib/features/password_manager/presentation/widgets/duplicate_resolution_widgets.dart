import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';

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

class ResolutionChoiceButtons extends StatelessWidget {
  final DuplicateResolutionChoice? selectedChoice;
  final ValueChanged<DuplicateResolutionChoice> onChoiceChanged;

  const ResolutionChoiceButtons({
    super.key,
    required this.selectedChoice,
    required this.onChoiceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<DuplicateResolutionChoice>(
      groupValue: selectedChoice,
      onChanged: (value) => onChoiceChanged(value!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.chooseResolutionAction,
            style: context.typography.labelLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          RadioListTile<DuplicateResolutionChoice>(
            title: Text(context.l10n.keepExistingTitle),
            subtitle: Text(context.l10n.keepExistingSubtitle),
            value: DuplicateResolutionChoice.keepExisting,
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<DuplicateResolutionChoice>(
            title: Text(context.l10n.replaceWithNewTitle),
            subtitle: Text(context.l10n.replaceWithNewSubtitle),
            value: DuplicateResolutionChoice.replaceWithNew,
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<DuplicateResolutionChoice>(
            title: Text(context.l10n.keepBothTitle),
            subtitle: Text(context.l10n.keepBothSubtitle),
            value: DuplicateResolutionChoice.keepBoth,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class BulkResolutionHeader extends StatelessWidget {
  final ValueChanged<DuplicateResolutionChoice> onChoiceSelected;

  const BulkResolutionHeader({super.key, required this.onChoiceSelected});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    return AppCard(
      backgroundColor: theme.primaryContainer.withValues(alpha: 0.1),
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.zap, size: AppIconSize.s, color: theme.primary),
              const SizedBox(width: AppSpacing.s),
              Text(
                l10n.bulkActionsTitle,
                style: context.typography.titleSmall?.copyWith(
                  color: theme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          Text(l10n.bulkActionsSubtitle, style: context.typography.bodySmall),
          const SizedBox(height: AppSpacing.m),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              _BulkActionButton(
                label: l10n.keepAllExisting,
                onPressed: () =>
                    onChoiceSelected(DuplicateResolutionChoice.keepExisting),
              ),
              _BulkActionButton(
                label: l10n.replaceAll,
                onPressed: () =>
                    onChoiceSelected(DuplicateResolutionChoice.replaceWithNew),
              ),
              _BulkActionButton(
                label: l10n.keepAllBothAction,
                onPressed: () =>
                    onChoiceSelected(DuplicateResolutionChoice.keepBoth),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BulkActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _BulkActionButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        side: BorderSide(color: theme.primary.withValues(alpha: 0.3)),
        foregroundColor: theme.primary,
        textStyle: context.typography.labelMedium,
      ),
      child: Text(label),
    );
  }
}
