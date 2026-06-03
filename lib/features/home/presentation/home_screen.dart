import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/utils/app_semantics.dart';
import 'package:passvault/features/home/domain/entities/grouped_home_entry.dart';
import 'package:passvault/features/home/presentation/bloc/password/password_bloc.dart';
import 'package:passvault/features/home/presentation/widgets/empty_password_state.dart';
import 'package:passvault/features/home/presentation/widgets/grouped_password_list_tile.dart';

/// Main landing screen of the application after authentication.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const fabSize = 56.0;
    final fabBottomOffset =
        AppSpacing.m + (kBottomNavigationBarHeight - fabSize) / 2 + bottomInset;
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: PageHeader(title: l10n.vault),
                ),
              ),
              BlocBuilder<PasswordBloc, PasswordState>(
                buildWhen: (previous, current) {
                  // Prevent list destruction during background refresh
                  if (previous is PasswordLoaded &&
                      current is PasswordLoading) {
                    return false;
                  }
                  return true;
                },
                builder: (context, state) {
                  if (state is PasswordLoading || state is PasswordInitial) {
                    return SliverFillRemaining(
                      child: Center(
                        child: AppSemantics.loading(
                          label: context.l10n.loadingPasswords,
                          child: const AppLoader(key: Key('home_loading')),
                        ),
                      ),
                    );
                  } else if (state is PasswordLoaded) {
                    if (state.groupedEntries.isEmpty) {
                      return const SliverFillRemaining(
                        child: EmptyPasswordState(),
                      );
                    }

                    return SliverPadding(
                      key: const Key('home_password_list'),
                      padding: EdgeInsets.only(
                        left: context.responsive(
                          AppSpacing.l,
                          tablet: AppSpacing.xl,
                        ),
                        right: context.responsive(
                          AppSpacing.l,
                          tablet: AppSpacing.xl,
                        ),
                        bottom: AppSpacing.xxl + fabBottomOffset + fabSize,
                      ),
                      sliver: context.isDesktop || context.isTablet
                          ? _HomeScreenGrid(groups: state.groupedEntries)
                          : _HomeScreenList(groups: state.groupedEntries),
                    );
                  } else if (state is PasswordError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          '${context.l10n.errorOccurred}: ${state.message}',
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
          Positioned(
            right: AppSpacing.m,
            bottom: fabBottomOffset,
            child: SizedBox(
              width: fabSize,
              height: fabSize,
              child: FloatingActionButton(
                key: const Key('home_add_password_fab'),
                heroTag: 'home_add_password_fab',
                onPressed: () => context.push(AppRoutes.addPassword),
                child: const Icon(LucideIcons.plus),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeScreenGrid extends StatelessWidget {
  final List<GroupedHomeEntry> groups;
  const _HomeScreenGrid({required this.groups});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isDesktop ? 3 : 2,
        mainAxisSpacing: AppSpacing.m,
        crossAxisSpacing: AppSpacing.m,
        childAspectRatio: AppDimensions.gridAspectRatio,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => AppAnimatedListItem(
          index: index,
          child: GroupedPasswordListTile(
            group: groups[index],
            onTap: () => _onGroupTap(context, groups[index]),
          ),
        ),
        childCount: groups.length,
      ),
    );
  }
}

class _HomeScreenList extends StatelessWidget {
  final List<GroupedHomeEntry> groups;
  const _HomeScreenList({required this.groups});

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.m),
      itemCount: groups.length,
      itemBuilder: (context, index) => RepaintBoundary(
        child: GroupedPasswordListTile(
          group: groups[index],
          onTap: () => _onGroupTap(context, groups[index]),
        ),
      ),
    );
  }
}

void _onGroupTap(BuildContext context, GroupedHomeEntry group) {
  if (group.accountCount == 1 && group.members.isNotEmpty) {
    context.push(AppRoutes.editPassword, extra: group.members.first);
    return;
  }

  context.push(AppRoutes.groupedPasswordDetailsPath(group.canonicalKey));
}
