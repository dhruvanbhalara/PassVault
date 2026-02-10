import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/config/routes/app_routes.dart';
import 'package:passvault/core/design_system/components/components.dart';
import 'package:passvault/core/design_system/theme/theme.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/features/home/presentation/bloc/password_bloc.dart';
import 'package:passvault/features/home/presentation/widgets/empty_password_state.dart';
import 'package:passvault/features/home/presentation/widgets/password_list_tile.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';

/// Main landing screen of the application after authentication.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<PasswordBloc>()..add(const LoadPasswords()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const Key('home_fab'),
        onPressed: () => context.push(AppRoutes.addPassword),
        child: const Icon(LucideIcons.plus),
      ),
      body: CustomScrollView(
        slivers: [
          _HomeAppBar(),
          BlocBuilder<PasswordBloc, PasswordState>(
            builder: (context, state) {
              if (state is PasswordLoading) {
                return const SliverFillRemaining(
                  child: Center(child: AppLoader(key: Key('home_loading'))),
                );
              } else if (state is PasswordLoaded) {
                if (state.passwords.isEmpty) {
                  return const SliverFillRemaining(child: EmptyPasswordState());
                }

                return SliverPadding(
                  key: const Key('home_password_list'),
                  padding: EdgeInsets.all(
                    context.responsive(AppSpacing.m, tablet: AppSpacing.l),
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

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return SliverAppBar(
      floating: true,
      pinned: true,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      title: Text(context.l10n.appName),
      actions: [
        IconButton(
          key: const Key('home_settings_button'),
          icon: Icon(LucideIcons.settings, color: theme.onVaultGradient),
          onPressed: () => context.push(AppRoutes.settings),
        ),
      ],
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
        (context, index) => _StaggeredAnimation(
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
          child: _StaggeredAnimation(
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

class _StaggeredAnimation extends StatelessWidget {
  final int index;
  final Widget child;
  const _StaggeredAnimation({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: AppDuration.normal + Duration(milliseconds: index * 50),
      child: child,
    );
  }
}
