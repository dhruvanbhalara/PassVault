import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/core/theme/app_animations.dart';
import 'package:passvault/core/theme/app_dimensions.dart';
import 'package:passvault/core/theme/app_theme_extension.dart';
import 'package:passvault/features/home/presentation/bloc/password_bloc.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/l10n/app_localizations.dart';

/// Main landing screen of the application after authentication.
///
/// Displays a list of stored passwords and provides access to settings
/// and the password creation flow.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<PasswordBloc>()..add(LoadPasswords()),
      child: const HomeView(),
    );
  }
}

/// The stateful UI for the home screen, handling scroll behavior and list display.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = context.theme;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const Key('home_fab'),
        onPressed: () {
          context.push('/add-password');
        },
        child: const Icon(LucideIcons.plus),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: AppDimensions.sliverAppBarExpandedHeight,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.appName,
                style: TextStyle(
                  color: theme.onVaultGradient,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              background: DecoratedBox(
                decoration: BoxDecoration(gradient: theme.vaultGradient),
              ),
            ),
            actions: [
              IconButton(
                key: const Key('home_settings_button'),
                icon: Icon(LucideIcons.settings, color: theme.onVaultGradient),
                onPressed: () {
                  context.push('/settings');
                },
              ),
            ],
          ),
          BlocBuilder<PasswordBloc, PasswordState>(
            builder: (context, state) {
              if (state is PasswordLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(key: Key('home_loading')),
                  ),
                );
              } else if (state is PasswordLoaded) {
                if (state.passwords.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: theme.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.l),
                                child: Icon(
                                  LucideIcons.shieldCheck,
                                  size: context.responsive(
                                    AppDimensions.emptyStateIconSize,
                                    tablet:
                                        AppDimensions.emptyStateIconSizeTablet,
                                  ),
                                  color: theme.primary.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.l),
                            Text(
                              l10n.noPasswords,
                              key: const Key('home_empty_text'),
                              textAlign: TextAlign.center,
                              style: context.typography.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final isDesktop = context.isDesktop;
                final isTablet = context.isTablet;

                if (isDesktop || isTablet) {
                  return SliverPadding(
                    key: const Key('home_password_list'),
                    padding: EdgeInsets.all(
                      context.responsive(AppSpacing.m, tablet: AppSpacing.l),
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isDesktop ? 3 : 2,
                        mainAxisSpacing: AppSpacing.m,
                        crossAxisSpacing: AppSpacing.m,
                        childAspectRatio: AppDimensions.gridAspectRatio,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final entry = state.passwords[index];
                        return FadeInUp(
                          duration:
                              AppDuration.normal +
                              Duration(milliseconds: index * 50),
                          child: PasswordListTile(entry: entry),
                        );
                      }, childCount: state.passwords.length),
                    ),
                  );
                }

                return SliverPadding(
                  key: const Key('home_password_list'),
                  padding: const EdgeInsets.all(AppSpacing.l),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final entry = state.passwords[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.m),
                        child: FadeInUp(
                          // Staggered entry animation using base normal duration
                          duration:
                              AppDuration.normal +
                              Duration(milliseconds: index * 50),
                          child: Dismissible(
                            key: Key(entry.id),
                            background: DecoratedBox(
                              decoration: BoxDecoration(
                                color: context.colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.l,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: AppSpacing.l,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    LucideIcons.trash2,
                                    color: context.colorScheme.onErrorContainer,
                                  ),
                                ),
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              context.read<PasswordBloc>().add(
                                DeletePassword(entry.id),
                              );
                            },
                            child: PasswordListTile(entry: entry),
                          ),
                        ),
                      );
                    }, childCount: state.passwords.length),
                  ),
                );
              } else if (state is PasswordError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('${l10n.errorOccurred}: ${state.message}'),
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

/// A list tile representing a single password entry in the vault.
class PasswordListTile extends StatelessWidget {
  final PasswordEntry entry;
  const PasswordListTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = context.theme;
    final textTheme = context.typography;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        leading: SizedBox(
          width: AppDimensions.listTileIconSize,
          height: AppDimensions.listTileIconSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.m),
            ),
            child: Center(
              child: Text(
                entry.appName.isNotEmpty ? entry.appName[0].toUpperCase() : '?',
                style: textTheme.titleMedium?.copyWith(color: theme.primary),
              ),
            ),
          ),
        ),
        title: Text(entry.appName, style: textTheme.titleMedium),
        subtitle: Text(entry.username, style: textTheme.bodyMedium),
        trailing: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.surfaceDim,
            borderRadius: BorderRadius.circular(AppRadius.s),
          ),
          child: IconButton(
            icon: const Icon(LucideIcons.copy, size: AppIconSize.m),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: entry.password));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.m),
                  ),
                  content: Text(l10n.passwordCopied),
                  // Short duration for quick confirmation feedback
                  duration: AppDuration.slow,
                ),
              );
            },
          ),
        ),
        onTap: () {
          context.push('/edit-password', extra: entry);
        },
      ),
    );
  }
}
