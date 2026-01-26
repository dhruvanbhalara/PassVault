import 'package:flutter/material.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';

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
