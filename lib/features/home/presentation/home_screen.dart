import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:passvault/core/di/injection.dart';
import 'package:passvault/core/theme/app_dimensions.dart';
import 'package:passvault/core/theme/app_theme_extension.dart';
import 'package:passvault/features/home/presentation/bloc/password_bloc.dart';
import 'package:passvault/features/password_manager/domain/entities/password_entry.dart';
import 'package:passvault/l10n/app_localizations.dart';

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

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
            title: Text(l10n.appName),
            floating: true,
            pinned: true,
            actions: [
              IconButton(
                key: const Key('home_settings_button'),
                icon: const Icon(LucideIcons.settings),
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
                        padding: const EdgeInsets.all(AppDimensions.spaceM),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(
                                AppDimensions.spaceL,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.primary.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                LucideIcons.shieldCheck,
                                size: 64,
                                color: context.colors.primary.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spaceL),
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
                return SliverPadding(
                  key: const Key('home_password_list'),
                  padding: const EdgeInsets.all(AppDimensions.spaceL),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final entry = state.passwords[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.spaceM,
                        ),
                        child: FadeInUp(
                          duration: Duration(milliseconds: 400 + (index * 50)),
                          child: Dismissible(
                            key: Key(entry.id),
                            background: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.errorContainer,
                                borderRadius: AppDimensions.borderRadiusL,
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(
                                right: AppDimensions.spaceL,
                              ),
                              child: Icon(
                                LucideIcons.trash2,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
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
                    child: Text("${l10n.errorOccurred}: ${state.message}"),
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

class PasswordListTile extends StatelessWidget {
  final PasswordEntry entry;
  const PasswordListTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final textTheme = context.typography;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceM,
          vertical: AppDimensions.spaceS,
        ),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.1),
            borderRadius: AppDimensions.borderRadiusM,
          ),
          child: Center(
            child: Text(
              entry.appName.isNotEmpty ? entry.appName[0].toUpperCase() : "?",
              style: textTheme.titleMedium?.copyWith(color: colors.primary),
            ),
          ),
        ),
        title: Text(entry.appName, style: textTheme.titleMedium),
        subtitle: Text(entry.username, style: textTheme.bodyMedium),
        trailing: Container(
          decoration: BoxDecoration(
            color: colors
                .surfaceDim, // Replaced surfaceContainerHighest.withValues(alpha: 0.3)
            borderRadius: AppDimensions.borderRadiusS,
          ),
          child: IconButton(
            icon: Icon(LucideIcons.copy, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: entry.password));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                  content: Text(l10n.passwordCopied),
                  duration: const Duration(seconds: 1),
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
