import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/password_manager/domain/entities/duplicate_password_entry.dart';
import 'package:passvault/features/password_manager/presentation/bloc/duplicate_resolution/duplicate_resolution_bloc.dart';
import 'package:passvault/features/password_manager/presentation/bloc/import_export/import_export_bloc.dart';
import 'package:passvault/features/password_manager/presentation/widgets/bulk_resolution_header.dart';
import 'package:passvault/features/password_manager/presentation/widgets/duplicate_card.dart';

/// Screen for resolving duplicate password entries detected during import.
class DuplicateResolutionScreen extends StatelessWidget {
  const DuplicateResolutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAmoled = context.isAmoled;
    final l10n = context.l10n;

    final importExportState = context.watch<ImportExportBloc>().state;
    final duplicates = importExportState is DuplicatesDetected
        ? importExportState.duplicates
        : <DuplicatePasswordEntry>[];

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
          builder: (context, state) {
            final isLoading =
                context.watch<ImportExportBloc>().state is ImportExportLoading;

            return switch (state) {
              DuplicateResolutionInitial(:final resolutions) => Scaffold(
                extendBody: true,
                bottomNavigationBar: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.l),
                    child: IgnorePointer(
                      ignoring: state.hasUnresolved,
                      child: AppButton(
                        key: const Key('resolve_duplicates_button'),
                        text: '${l10n.apply} (${resolutions.length})',
                        isLoading: isLoading,
                        onPressed: () => _handleResolve(context, state),
                        hasGlow: isAmoled,
                      ),
                    ),
                  ),
                ),
                body: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.l,
                            AppSpacing.m,
                            AppSpacing.l,
                            AppSpacing.s,
                          ),
                          child: PageHeader(
                            title: l10n.resolveDuplicatesTitle,
                            showBack: true,
                            onBack: () => context.pop(),
                          ),
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: false,
                      floating: true,
                      delegate: StickyHeaderDelegate(
                        minHeight: 60.0,
                        maxHeight: 60.0,
                        child: _InfoBanner(count: resolutions.length),
                      ),
                    ),

                    if (isLoading)
                      const SliverFillRemaining(
                        child: Center(child: AppLoader()),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.all(AppSpacing.l),
                        sliver: SliverList.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: AppSpacing.m),
                          itemCount: resolutions.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.l,
                                ),
                                child: BulkResolutionHeader(
                                  onChoiceSelected: (choice) => context
                                      .read<DuplicateResolutionBloc>()
                                      .add(BulkResolutionOptionSet(choice)),
                                ),
                              );
                            }
                            final duplicate = resolutions[index - 1];
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
                    if (resolutions.isNotEmpty)
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            };
          },
        ),
      ),
    );
  }

  void _handleResolve(BuildContext context, DuplicateResolutionState state) {
    final l10n = context.l10n;
    if (state.hasUnresolved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.resolveConflictsDesc),
          backgroundColor: context.theme.error,
        ),
      );
      return;
    }

    context.read<ImportExportBloc>().add(
      ResolveDuplicatesEvent(state.resolutions),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final int count;

  const _InfoBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: theme.primary.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.triangleAlert, color: theme.primary, size: 20),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Text(
              context.l10n.duplicatesFoundCount(count),
              style: context.typography.bodyMedium?.copyWith(
                color: theme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
