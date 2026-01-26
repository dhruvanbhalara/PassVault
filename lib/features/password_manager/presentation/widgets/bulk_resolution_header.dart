import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';

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
