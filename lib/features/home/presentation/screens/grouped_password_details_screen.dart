import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/features/home/domain/entities/grouped_home_entry.dart';
import 'package:passvault/features/home/presentation/bloc/password/password_bloc.dart';
import 'package:passvault/features/home/presentation/widgets/password_list_tile.dart';

class GroupedPasswordDetailsScreen extends StatelessWidget {
  final String groupKey;

  const GroupedPasswordDetailsScreen({super.key, required this.groupKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordBloc, PasswordState>(
      builder: (context, state) {
        if (state is! PasswordLoaded) {
          return const _GroupedDetailsLoadingScaffold();
        }

        GroupedHomeEntry? group;
        for (final entry in state.groupedEntries) {
          if (entry.canonicalKey == groupKey) {
            group = entry;
            break;
          }
        }
        if (group == null) {
          return const _GroupedDetailsNotFoundScaffold();
        }

        return _GroupedDetailsLoadedScaffold(group: group);
      },
    );
  }
}

class _GroupedDetailsLoadingScaffold extends StatelessWidget {
  const _GroupedDetailsLoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: AppLoader(key: Key('grouped_details_loading'))),
    );
  }
}

class _GroupedDetailsNotFoundScaffold extends StatelessWidget {
  const _GroupedDetailsNotFoundScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          context.l10n.groupedEntryNotFound,
          key: const Key('grouped_details_not_found_text'),
        ),
      ),
    );
  }
}

class _GroupedDetailsLoadedScaffold extends StatelessWidget {
  final GroupedHomeEntry group;

  const _GroupedDetailsLoadedScaffold({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(group.displayName)),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.l,
                  AppSpacing.m,
                  AppSpacing.l,
                  AppSpacing.m,
                ),
                child: Text(
                  context.l10n.groupedCredentialCount(group.accountCount),
                  key: const Key('grouped_details_count_text'),
                  style: context.typography.titleMedium,
                ),
              ),
            ),
            SliverPadding(
              key: const Key('grouped_details_member_list'),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.l,
                0,
                AppSpacing.l,
                AppSpacing.xl,
              ),
              sliver: SliverList.separated(
                itemCount: group.members.length,
                itemBuilder: (context, index) {
                  final entry = group.members[index];
                  return PasswordListTile(
                    entry: entry,
                    onTap: () =>
                        context.push(AppRoutes.editPassword, extra: entry),
                    onDismissed: () => context.read<PasswordBloc>().add(
                      DeletePassword(entry.id),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.m),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
