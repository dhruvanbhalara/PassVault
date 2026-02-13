import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/utils/app_semantics.dart';
import 'package:passvault/features/home/presentation/bloc/password_bloc.dart';
import 'package:passvault/features/home/presentation/widgets/empty_password_state.dart';
import 'package:passvault/features/home/presentation/widgets/password_list_tile.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

/// Main landing screen of the application after authentication.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const Key('home_fab'),
        onPressed: () => context.push(AppRoutes.addPassword),
        backgroundColor: theme.primary,
        foregroundColor: theme.onPrimary,
        child: const Icon(LucideIcons.plus),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            title: Text(l10n.vault),
            floating: true,
            pinned: true,
            scrolledUnderElevation: 0,
            backgroundColor: theme.background.withValues(alpha: 0),
          ),
          BlocBuilder<PasswordBloc, PasswordState>(
            builder: (context, state) {
              if (state is PasswordLoading) {
                return SliverFillRemaining(
                  child: Center(
                    child: AppSemantics.loading(
                      label: context.l10n.loadingPasswords,
                      child: const AppLoader(key: Key('home_loading')),
                    ),
                  ),
                );
              } else if (state is PasswordLoaded) {
                if (state.passwords.isEmpty) {
                  return const SliverFillRemaining(child: EmptyPasswordState());
                }

                return SliverPadding(
                  key: const Key('home_password_list'),
                  padding: EdgeInsets.all(
                    context.responsive(AppSpacing.l, tablet: AppSpacing.xl),
                  ),
                  sliver: context.isDesktop || context.isTablet
                      ? _HomeScreenGrid(passwords: state.passwords)
                      : _HomeScreenList(passwords: state.passwords),
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
    );
  }
}

class _HomeScreenGrid extends StatelessWidget {
  final List<PasswordEntry> passwords;
  const _HomeScreenGrid({required this.passwords});

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
          child: PasswordListTile(
            entry: passwords[index],
            onTap: () =>
                context.push(AppRoutes.editPassword, extra: passwords[index]),
            onDismissed: () => context.read<PasswordBloc>().add(
              DeletePassword(passwords[index].id),
            ),
          ),
        ),
        childCount: passwords.length,
      ),
    );
  }
}

class _HomeScreenList extends StatelessWidget {
  final List<PasswordEntry> passwords;
  const _HomeScreenList({required this.passwords});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.m),
          child: AppAnimatedListItem(
            index: index,
            child: PasswordListTile(
              entry: passwords[index],
              onTap: () =>
                  context.push(AppRoutes.editPassword, extra: passwords[index]),
              onDismissed: () => context.read<PasswordBloc>().add(
                DeletePassword(passwords[index].id),
              ),
            ),
          ),
        ),
        childCount: passwords.length,
      ),
    );
  }
}
