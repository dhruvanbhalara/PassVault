import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';

/// Screen for resolving duplicate password entries detected during import.
///
/// Allows users to choose how to handle each duplicate:
/// - Keep existing
/// - Replace with new
/// - Keep both
class DuplicateResolutionScreen extends StatelessWidget {
  final List<DuplicatePasswordEntry> duplicates;

  const DuplicateResolutionScreen({super.key, required this.duplicates});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ImportExportBloc>(),
      child: DuplicateResolutionView(duplicates: duplicates),
    );
  }
}

@visibleForTesting
class DuplicateResolutionView extends StatefulWidget {
  final List<DuplicatePasswordEntry> duplicates;

  const DuplicateResolutionView({super.key, required this.duplicates});

  @override
  State<DuplicateResolutionView> createState() =>
      _DuplicateResolutionViewState();
}

class _DuplicateResolutionViewState extends State<DuplicateResolutionView> {
  late List<DuplicatePasswordEntry> _resolutions;

  @override
  void initState() {
    super.initState();
    _resolutions = widget.duplicates;
  }

  void _updateChoice(int index, DuplicateResolutionChoice choice) {
    setState(() {
      _resolutions[index] = _resolutions[index].copyWith(userChoice: choice);
    });
  }

  void _setAllChoices(DuplicateResolutionChoice choice) {
    setState(() {
      _resolutions = _resolutions
          .map((r) => r.copyWith(userChoice: choice))
          .toList();
    });
  }

  void _handleResolve(BuildContext context) {
    final unresolved = _resolutions.where((r) => !r.isResolved).toList();

    if (unresolved.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please resolve all ${unresolved.length} remaining duplicates',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    context.read<ImportExportBloc>().add(ResolveDuplicatesEvent(_resolutions));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ImportExportBloc, ImportExportState>(
      listener: (context, state) {
        if (state is DuplicatesResolved) {
          // Pop back to Settings screen
          context.pop();
        } else if (state is ImportExportFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ImportExportLoading;

        return Scaffold(
          appBar: AppBar(title: const Text('Resolve Duplicates')),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: AppButton(
                key: const Key('resolve_duplicates_button'),
                text: 'Resolve ${_resolutions.length} Duplicates',
                isLoading: isLoading,
                onPressed: (_resolutions.any((r) => !r.isResolved))
                    ? null
                    : () => _handleResolve(context),
                icon: LucideIcons.circleCheck,
              ),
            ),
          ),
          body: Column(
            children: [
              // Info banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.m),
                color: context.theme.surfaceDim,
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.triangleAlert,
                      color: context.theme.onSurface,
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Text(
                        '${_resolutions.length} duplicate(s) found',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: context.theme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Loading indicator
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.l),
                  child: AppLoader(size: 40),
                ),

              // Duplicates list
              if (!isLoading)
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    itemCount: _resolutions.length + 1, // +1 for bulk header
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.m),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _BulkActionHeader(
                          onChoiceSelected: _setAllChoices,
                        );
                      }
                      final duplicate = _resolutions[index - 1];
                      return _DuplicateCard(
                        key: Key('duplicate_card_${index - 1}'),
                        duplicate: duplicate,
                        onChoiceChanged: (choice) =>
                            _updateChoice(index - 1, choice),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Card displaying a duplicate password entry with resolution options.
class _DuplicateCard extends StatelessWidget {
  final DuplicatePasswordEntry duplicate;
  final ValueChanged<DuplicateResolutionChoice> onChoiceChanged;

  const _DuplicateCard({
    super.key,
    required this.duplicate,
    required this.onChoiceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(LucideIcons.copy, size: AppIconSize.s),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Text(
                  duplicate.existingEntry.appName,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Username: ${duplicate.existingEntry.username}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.m),

          // Conflict reason
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
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.theme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.m),

          // Resolution choices
          _ResolutionChoiceButtons(
            selectedChoice: duplicate.userChoice,
            onChoiceChanged: onChoiceChanged,
          ),
        ],
      ),
    );
  }
}

/// Radio buttons for selecting duplicate resolution choice.
class _ResolutionChoiceButtons extends StatelessWidget {
  final DuplicateResolutionChoice? selectedChoice;
  final ValueChanged<DuplicateResolutionChoice> onChoiceChanged;

  const _ResolutionChoiceButtons({
    required this.selectedChoice,
    required this.onChoiceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose action:', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        RadioListTile<DuplicateResolutionChoice>(
          title: const Text('Keep Existing'),
          subtitle: const Text('Ignore imported entry'),
          value: DuplicateResolutionChoice.keepExisting,
          groupValue: selectedChoice,
          onChanged: (value) => onChoiceChanged(value!),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<DuplicateResolutionChoice>(
          title: const Text('Replace with New'),
          subtitle: const Text('Update with imported data'),
          value: DuplicateResolutionChoice.replaceWithNew,
          groupValue: selectedChoice,
          onChanged: (value) => onChoiceChanged(value!),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<DuplicateResolutionChoice>(
          title: const Text('Keep Both'),
          subtitle: const Text('Save both entries'),
          value: DuplicateResolutionChoice.keepBoth,
          groupValue: selectedChoice,
          onChanged: (value) => onChoiceChanged(value!),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

/// Header widget for bulk resolution actions.
class _BulkActionHeader extends StatelessWidget {
  final ValueChanged<DuplicateResolutionChoice> onChoiceSelected;

  const _BulkActionHeader({required this.onChoiceSelected});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: context.theme.primaryContainer.withValues(alpha: 0.1),
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.zap,
                size: AppIconSize.s,
                color: context.theme.primary,
              ),
              const SizedBox(width: AppSpacing.s),
              Text(
                'Bulk Actions',
                style: context.typography.titleSmall?.copyWith(
                  color: context.theme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'Apply a single decision to all remaining conflicts:',
            style: context.typography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.m),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              _BulkActionButton(
                label: 'Keep All Existing',
                onPressed: () =>
                    onChoiceSelected(DuplicateResolutionChoice.keepExisting),
              ),
              _BulkActionButton(
                label: 'Replace All',
                onPressed: () =>
                    onChoiceSelected(DuplicateResolutionChoice.replaceWithNew),
              ),
              _BulkActionButton(
                label: 'Keep All Both',
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
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        side: BorderSide(color: context.theme.primary.withValues(alpha: 0.3)),
        foregroundColor: context.theme.primary,
        textStyle: context.typography.labelMedium,
      ),
      child: Text(label),
    );
  }
}
