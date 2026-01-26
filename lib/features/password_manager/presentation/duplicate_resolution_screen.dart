import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/presentation/bloc/duplicate_resolution/duplicate_resolution_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_event.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export_state.dart';
import 'package:passvault/features/password_manager/presentation/widgets/duplicate_resolution_widgets.dart';

/// Screen for resolving duplicate password entries detected during import.
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
          backgroundColor: context.colorScheme.error,
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
      create: (_) => DuplicateResolutionBloc(duplicates),
      child: BlocListener<ImportExportBloc, ImportExportState>(
        listener: (context, state) {
          if (state is DuplicatesResolved) {
            context.pop();
          } else if (state is ImportExportFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.theme.error,
              ),
            );
          }
        },
        child: BlocBuilder<DuplicateResolutionBloc, DuplicateResolutionState>(
          builder: (context, resolutionState) {
            final isLoading =
                context.watch<ImportExportBloc>().state is ImportExportLoading;

            return Scaffold(
              appBar: AppBar(title: Text(context.l10n.resolveDuplicatesTitle)),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  child: AppButton(
                    key: const Key('resolve_duplicates_button'),
                    text: context.l10n.resolveCountDuplicates(
                      resolutionState.resolutions.length,
                    ),
                    isLoading: isLoading,
                    onPressed: resolutionState.hasUnresolved
                        ? null
                        : () => _handleResolve(context, resolutionState),
                    icon: LucideIcons.circleCheck,
                  ),
                ),
              ),
              body: Column(
                children: [
                  _InfoBanner(count: resolutionState.resolutions.length),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.l),
                      child: AppLoader(size: 40),
                    ),
                  if (!isLoading)
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        itemCount: resolutionState.resolutions.length + 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.m),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return BulkResolutionHeader(
                              onChoiceSelected: (choice) => context
                                  .read<DuplicateResolutionBloc>()
                                  .add(BulkResolutionOptionSet(choice)),
                            );
                          }
                          final duplicate =
                              resolutionState.resolutions[index - 1];
                          return DuplicateCard(
                            key: Key('duplicate_card_${index - 1}'),
                            duplicate: duplicate,
                            onChoiceChanged: (choice) =>
                                context.read<DuplicateResolutionBloc>().add(
                                  ResolutionOptionUpdated(index - 1, choice),
                                ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final int count;

  const _InfoBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.m),
      color: context.theme.surfaceDim,
      child: Row(
        children: [
          Icon(LucideIcons.triangleAlert, color: context.theme.onSurface),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Text(
              context.l10n.duplicatesFoundCount(count),
              style: context.typography.titleMedium?.copyWith(
                color: context.theme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
