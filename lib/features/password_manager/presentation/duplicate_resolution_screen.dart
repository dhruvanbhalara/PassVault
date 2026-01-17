import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_resolution_choice.dart';
import 'package:passvault/features/password_manager/presentation/bloc/duplicate_resolution/duplicate_resolution_cubit.dart';
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
class DuplicateResolutionView extends StatelessWidget {
  final List<DuplicatePasswordEntry> duplicates;

  const DuplicateResolutionView({super.key, required this.duplicates});

  void _handleResolve(BuildContext context, DuplicateResolutionState state) {
    if (state.hasUnresolved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.resolveRemainingDuplicates(state.unresolved.length),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    context.read<ImportExportBloc>().add(
      ResolveDuplicatesEvent(state.resolutions),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DuplicateResolutionCubit(duplicates),
      child: Builder(
        builder: (context) {
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
            builder: (context, importState) {
              final isLoading = importState is ImportExportLoading;

              return BlocBuilder<
                DuplicateResolutionCubit,
                DuplicateResolutionState
              >(
                builder: (context, resolutionState) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(context.l10n.resolveDuplicatesTitle),
                    ),
                    bottomNavigationBar: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        child: AppButton(
                          key: const Key('resolve_duplicates_button'),
                          text: context.l10n.resolveCountDuplicates(
                            resolutionState.resolutions.length,
                          ),
                          isLoading: isLoading,
                          onPressed: (resolutionState.hasUnresolved)
                              ? null
                              : () => _handleResolve(context, resolutionState),
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
                                  context.l10n.duplicatesFoundCount(
                                    resolutionState.resolutions.length,
                                  ),
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
                              itemCount:
                                  resolutionState.resolutions.length +
                                  1, // +1 for bulk header
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: AppSpacing.m),
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return _BulkActionHeader(
                                    onChoiceSelected: (choice) => context
                                        .read<DuplicateResolutionCubit>()
                                        .setAllChoices(choice),
                                  );
                                }
                                final duplicate =
                                    resolutionState.resolutions[index - 1];
                                return _DuplicateCard(
                                  key: Key('duplicate_card_${index - 1}'),
                                  duplicate: duplicate,
                                  onChoiceChanged: (choice) => context
                                      .read<DuplicateResolutionCubit>()
                                      .updateChoice(index - 1, choice),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
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
            '${context.l10n.usernameLabel}: ${duplicate.existingEntry.username}',
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
    return RadioGroup<DuplicateResolutionChoice>(
      groupValue: selectedChoice,
      onChanged: (value) => onChoiceChanged(value!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.chooseResolutionAction,
            style: Theme.of(context).textTheme.labelLarge,
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
                context.l10n.bulkActionsTitle,
                style: context.typography.titleSmall?.copyWith(
                  color: context.theme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            context.l10n.bulkActionsSubtitle,
            style: context.typography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.m),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              _BulkActionButton(
                label: context.l10n.keepAllExisting,
                onPressed: () =>
                    onChoiceSelected(DuplicateResolutionChoice.keepExisting),
              ),
              _BulkActionButton(
                label: context.l10n.replaceAll,
                onPressed: () =>
                    onChoiceSelected(DuplicateResolutionChoice.replaceWithNew),
              ),
              _BulkActionButton(
                label: context.l10n.keepAllBothAction,
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
